FROM quay.io/frrouting/frr:master

RUN apk add --no-cache tcpdump iputils

# RUN sed -i 's/bgpd=no/bgpd=yes/' /etc/frr/daemons
# RUN sed -i 's/ospfd=no/ospfd=yes/' /etc/frr/daemons
# RUN sed -i 's/isisd=no/isisd=yes/' /etc/frr/daemons

# COPY FRR/frr.conf /etc/frr
COPY FRR/vtysh.conf /etc/frr
COPY FRR/daemons /etc/frr

# ENTRYPOINT sh -c "/usr/lib/frr/docker-start & exec sh"