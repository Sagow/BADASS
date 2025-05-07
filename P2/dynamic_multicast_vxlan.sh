#!/bin/bash

host1="host_mdelwaul-1"
host2="host_mdelwaul-2"
router1="router_mdelwaul-1"
router2="router_mdelwaul-2"

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
setup_router() {
  local container_id=$1
  local local_ip=$2

  docker exec "$container_id" sh -c "
    ip addr flush dev eth0 2>/dev/null
    ip link del vxlan10 2>/dev/null
    ip link del br0 2>/dev/null

    ip addr add $local_ip dev eth0
    ip link add br0 type bridge
    ip link set dev br0 up

    ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789

    brctl addif br0 eth1
    brctl addif br0 vxlan10
    ip link set dev vxlan10 up
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
    "$router1")
      setup_router $container_id "10.1.1.1/24"
      ;;
    "$router2")
      setup_router $container_id "10.1.1.2/24"
      ;;
    *)
		  echo "No match for container $container_id, skipping..."
		  ;;
		esac
  done
}

main
