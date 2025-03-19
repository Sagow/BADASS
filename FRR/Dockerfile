FROM quay.io/frrouting/frr:master
#ENV PATH="/usr/lib/frr:${PATH}"

RUN apk add --no-cache tcpdump iputils

RUN sed -i 's/bgpd=no/bgpd=yes/' /etc/frr/daemons
RUN sed -i 's/ospfd=no/ospfd=yes/' /etc/frr/daemons
RUN sed -i 's/isisd=no/isisd=yes/' /etc/frr/daemons

# Set correct permissions for frr user on necessary directories
#RUN chown -R frr:frr /etc/frr /var/run/frr


# Make sure the root is used for running FRR processes (needed)
# USER root

ENTRYPOINT sh -c "/usr/lib/frr/docker-start & exec sh"