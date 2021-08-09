FROM adakailabs/multi_cardano_base:1.28.0 AS build
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

COPY tmp/gocnode_* /tmp

RUN test $(uname -m) != x86_64 || { \
  	mv /tmp/gocnode_amd64 /usr/local/bin/gocnode ;}

RUN test $(uname -m) != aarch64 || { \
  	mv /tmp/gocnode_arm64 /usr/local/bin/gocnode ;}

RUN apt-get update && apt-get install libcap2-bin -y 

RUN setcap 'cap_net_raw+eip' /usr/local/bin/gocnode

#RUN chmod +s /usr/local/bin/gocnode

USER lovelace

EXPOSE 3001
EXPOSE 9100
EXPOSE 12798

# Set cardano-node as the entrypoint and by default just print the version.
ENTRYPOINT ["gocnode"]
CMD ["--id","0" ]

