FROM quay.io/frrouting/frr:master
ENV PATH="/usr/lib/frr:${PATH}"

COPY frr.conf /etc/frr
COPY vtysh.conf /etc/frr
COPY daemons /etc/frr