FROM adakailabs/multi_cardano_base:1.27.0 AS build
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

# Build the final stage and copy the build artifacts from the previous stage.
FROM adakailabs/multi_ubuntu_base:latest
COPY --from=build /usr/local/lib/libsodium* /usr/local/lib/
COPY --from=build /opt/bin/cardano-cli /usr/local/bin/
COPY --from=build /opt/bin/cardano-node /usr/local/bin/
COPY --from=build /usr/local/bin/node_exporter /usr/local/bin
COPY --from=build /usr/local/bin/argsparse* /usr/local/bin/

ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

USER root

#RUN mkdir -p /etc/cardano/testsecrets 

#COPY secrets/* /etc/cardano/testsecrets/

# Copy over other resources from the build context.
#COPY config /etc/cardano/config

# RUN test $(uname -m) != x86_64 || { \
#  	wget -O go.tar.gz https://golang.org/dl/go1.16.3.linux-amd64.tar.gz;}

# RUN test $(uname -m) != aarch64 || { \
# 	wget -O go.tar.gz https://golang.org/dl/go1.16.3.linux-arm64.tar.gz;}

# RUN tar -xvzf go.tar.gz && rm go.tar.gz && mv go /usr/local/go

# RUN apt-get update -y && apt-get install make -y 

# RUN git clone https://github.com/adakailabs/gocnode.git && cd gocnode && PATH=${PATH}:/usr/local/go/bin make gocnode && mv gocnode /usr/local/bin 

#RUN apt-get update -y && apt-get install libnuma-dev -y 

COPY tmp/gocnode_* /tmp

RUN test $(uname -m) != x86_64 || { \
  	mv /tmp/gocnode_amd64 /usr/local/bin/gocnode ;}

RUN test $(uname -m) != aarch64 || { \
  	mv /tmp/gocnode_arm64 /usr/local/bin/gocnode ;}

USER lovelace

EXPOSE 3001
EXPOSE 9100
EXPOSE 12798

# Set cardano-node as the entrypoint and by default just print the version.
ENTRYPOINT ["gocnode"]
CMD ["--id","0" ]

