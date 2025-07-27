#!/bin/bash

host1="host_mdelwaul-1"
host2="host_mdelwaul-2"
host3="host_mdelwaul-3"
router1="router_mdelwaul-1"
router2="router_mdelwaul-2"
router3="router_mdelwaul-3"
router4="router_mdelwaul-4"

# Define host IP setups
setup_host() {
  local container_id=$1
  local ip=$2
  docker exec "$container_id" sh -c "
    ip addr flush dev eth0 2>/dev/null
    ip addr add $ip dev eth0
  "
}

# Define router setup function (shared logic)
setup_spine_router() {
  local container_id=$1
  local local_ip=$2

  docker exec "$container_id" sh -c "
    # Nettoyage
    ip addr flush dev eth0 2>/dev/null
    ip addr flush dev eth1 2>/dev/null
    ip addr flush dev eth2 2>/dev/null
    ip link del vxlan10 2>/dev/null
    ip link del br0 2>/dev/null

    # Préparer les interfaces
    ip link set eth0 up
    ip link set eth1 up
    ip link set eth2 up

    # Créer le bridge
    ip link add br0 type bridge
    ip link set dev br0 up

    # Ajouter les interfaces physiques au bridge
    brctl addif br0 eth0
    brctl addif br0 eth1
    brctl addif br0 eth2

    # Créer et ajouter l'interface VXLAN
    ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789 local $local_ip
    ip link set dev vxlan10 up
    brctl addif br0 vxlan10

    # Donner une IP à eth0 (hors bridge) pour le VTEP local
    ip addr add $local_ip/24 dev eth0

    # FRR / vtysh
    vtysh << EOF
configure terminal
hostname $router1
no ipv6 forwarding

interface lo
 ip address 10.1.1.1/32

interface eth0
 ip address $local_ip/24

router bgp 65001
 bgp router-id 10.1.1.1
 neighbor ibgp peer-group
 neighbor ibgp remote-as 65001
 neighbor ibgp update-source lo
 bgp listen range 10.1.1.0/29 peer-group ibgp

 address-family l2vpn evpn
  neighbor ibgp activate
  neighbor ibgp route-reflector-client
 exit-address-family

router ospf
 network 0.0.0.0/0 area 0

line vty
EOF
"
}

setup_leaf_router() {
  local container_id=$1
  local local_ip=$2
  local hostname=$3
  local eth_port=$4

  docker exec "$container_id" sh -c "
    ip addr flush dev eth0 2>/dev/null
    ip link del vxlan10 2>/dev/null
    ip link del br0 2>/dev/null

    ip addr add $local_ip/24 dev eth0
    ip link add br0 type bridge
    ip link set dev br0 up

    ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789

    brctl addif br0 eth1
    brctl addif br0 vxlan10
    ip link set dev vxlan10 up

    vtysh << EOF
configure terminal
hostname $hostname
no ipv6 forwarding

no router ospf
router ospf
  passive-inerface lo

interface eth0
 ip address $local_ip/30
 ip ospf area 0

interface lo
 ip address $local_ip/32
 ip ospf area 0

router bgp 65001
 neighbor 10.1.1.$eth_port remote-as 65001
 neighbor 10.1.1.$eth_port update-source lo

 address-family l2vpn evpn
  neighbor 10.1.1.$eth_port activate
  advertise-all-vni
 exit-address-family

EOF
"
}

main() {
  for container_id in $(docker ps -q); do
    # find associated hostname for each container id
    name=$(docker exec -i "$container_id" hostname)
    name=$(docker exec -i "$container_id" hostname)

    echo "Inspecting and configuring container: $name ($container_id)"

    case "$name" in
    "$host1")
    # arguments : container, new ip
      setup_host $container_id "30.1.1.1/24"
      ;;
    "$host2")
      setup_host $container_id "30.1.1.2/24"
      ;;
    "$host3")
      setup_host $container_id "30.1.1.3/24"
      ;;
    "$router1")
      setup_spine_router $container_id "10.1.1.1" $router1
      ;;
    "$router2")
      setup_leaf_router $container_id "10.1.1.2" $router2 1
      ;;
    "$router3")
      setup_leaf_router $container_id "10.1.1.3" $router3 5
      ;;
    "$router4")
      setup_leaf_router $container_id "10.1.1.4" $router4 9
      ;;
    *)
		  echo "No match for container $container_id, skipping..."
		  ;;
		esac
  done
}

main
