# BADASS

## TODO

- [ ] Setup VM using Vagrant
- [ ] P1 (GNS3)
- [ ] P2 (VXLAN)
- [ ] P3 (EVPN)

## Terms

- **Autonomous System (AS)** : A very large network or group of networks with a single routing policy. They have a unique number (ASN).
Data packets cross the Internet by hopping from AS to AS until they reach the AS that contains their destination Internet Protocol (IP) address.
Every AS controls a specific set of IP addresses (IP address space).

- **Border Gateway Protocol (BGP)** : the postal service of the Internet.
When data sent via the Internet, BGP is responsible for looking at all of the available paths that data could travel and picking the best route,
which usually means hopping between Autonomous Systems.
BGP is the protocol that makes the Internet work by enabling data routing.

- **Ethernet VPN (EVPN)** : A control-plane solution (part of a network that controls how data is forwarded) for VXLAN, MPLS, or SRv6 overlays that
   allows efficient and scalable multi-tenancy in data centers and service provider networks.

- **Internet Control Message Protocol (ICMP)** : The Internet Control Message Protocol (ICMP) is a network layer protocol used by network devices to diagnose network
  communication issues. ICMP is mainly used to determine whether or not data is reaching its intended destination in a timely manner. Commonly, the ICMP protocol is used on network devices, such as routers.

- **Intermediate System to Intermediate System (IS-IS)** : another link-state routing protocol, but it is less commonly used than OSPF (in service provider networks).
  It builds a map of the network and calculates the best path for routing traffic, but can be used for both IP and non-IP traffic.
  It has fewer protocol-specific overheads and allows more flexibility in network design compared to OSPF.

- Local Area Network (LAN) : ...
- Media Access Control (MAC) : ...
- Multiprotocol BGP (MP-BGP) : ...

- **Multiprotocol Label Switching (MPLS)** : high-performance network routing technique that directs data based on labels instead of traditional IP routing.
It creates virtual paths (Label-Switched Paths - LSPs) across a provider network to improve speed, efficiency, and scalability.

- **Network Layer Reachability Information (NLRI)** : NLRI in BGP is essentially the content of the message about available routes. It tells us what series of
  internet addresses are reachable via a specific route and is a crucial part of the BGP routing table.

- **Open Shortest Path First (OSPF)** : link-state routing protocol used in IP networks. Routers exchange link state information with their neighbors, allowing them
  to have a complete view of the network topology. OSPF uses Dijkstra's Shortest Path First (SPF) algorithm to compute the shortest path tree.

- Route Reflector (RR) : ...
- Virtual Network Interface (VNI) : ...
- Virtual Private Network (VPN) : ...
- Virtual Tunnel Endpoint (VTEP) : ...

- **Virtual eXtensible LAN (VXLAN)** : a tunneling protocol that tunnels Ethernet (layer 2) traffic over an IP (layer 3) network. With BGP, VXLAN is used to encapsulate
  the traffic between switches, allowing L2 traffic to flow over the L3 network. which means even if the end hosts are in different data centers or geographic regions,
  they can still communicate as if they were on the same local network.

## Technologies :

- Alpine : ...

- **BusyBox** : s, mv, etc... these commands are part of GNU Coreutils package and most Linux distributions have it preinstalled.
BusyBox is an alternative to GNU Coreutils. It is open-source and provides a stripped down implementation of around 400 common UNIX/Linux command
(removes the uncommon, rarely used command options, everything fits under 1 MB).

- Docker : ...
- FRRouting : ...
- Graphical Network Simulator-3 (GNS3) : ...

## Commands

- `find -maxdepth 2 -ls`

## Readings

- https://en.wikipedia.org/wiki/Graphical_Network_Simulator-3
- https://en.wikipedia.org/wiki/Border_Gateway_Protocol
- https://en.wikipedia.org/wiki/Virtual_Extensible_LAN
- https://en.wikipedia.org/wiki/Autonomous_system_(Internet)
- https://www.cloudflare.com/fr-fr/learning/security/glossary/what-is-bgp/
- https://notes.networklessons.com/bgp-network-layer-reachability-information-nlri

## Videos

- Part 1: https://www.youtube.com/watch?v=D4nk5VSUelg
- Part 2: https://www.youtube.com/watch?v=u1ka-S6F9UI
- Part 3: https://www.youtube.com/watch?v=Ek7kFDwUJBM

## Command to temporary add more flexibility to kernel memory handling

sudo sysctl -w vm.overcommit_memory=1