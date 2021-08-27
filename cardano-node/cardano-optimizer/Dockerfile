FROM adakailabs/multi_ubuntu_base:latest
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

USER root

COPY tmp/gocnode_* /tmp

RUN test $(uname -m) != x86_64 || { \
  	mv /tmp/gocnode_amd64 /usr/local/bin/gocnode ;}

RUN test $(uname -m) != aarch64 || { \
  	mv /tmp/gocnode_arm64 /usr/local/bin/gocnode ;}

RUN apt-get update && apt-get install libcap2-bin -y 

RUN setcap 'cap_net_raw+eip' /usr/local/bin/gocnode

#RUN chmod +s /usr/local/bin/gocnode

EXPOSE 3001
EXPOSE 9100
EXPOSE 12798

# Set cardano-node as the entrypoint and by default just print the version.
ENTRYPOINT ["gocnode"]
CMD ["--id","0" ]

