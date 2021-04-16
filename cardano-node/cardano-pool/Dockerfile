ARG CARDANO_NODE_BASE
FROM $CARDANO_NODE_BASE AS build
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

USER root
RUN apt-get update && apt-get install jq  -y 
USER lovelace

# Build the final stage and copy the build artifacts from the previous stage.
FROM adakailabs/ubuntu-base:latest
COPY --from=build /usr/local/lib/libsodium* /usr/local/lib/
COPY --from=build /opt/bin/cardano-cli /usr/local/bin/
COPY --from=build /opt/bin/cardano-node /usr/local/bin/
COPY --from=build /usr/local/bin/node_exporter /usr/local/bin
COPY --from=build /usr/local/bin/argsparse* /usr/local/bin/
COPY --from=build /usr/local/cardano/ /usr/local/cardano/


ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"



# Expose prometheus monitoring ports
USER root
RUN chown -R lovelace:lovelace /usr/local/cardano/ && mkdir -p /etc/cardano/testsecrets 
COPY secrets/* /etc/cardano/testsecrets/
RUN apt-get update && apt-get install jq netcat dnsutils  iotop iftop -y 

# Copy over other resources from the build context.
COPY config /etc/cardano/config

COPY scripts/* /usr/local/bin/

RUN chown -R lovelace:lovelace /usr/local/cardano/

COPY tmp/gocnode /usr/local/bin/

USER lovelace

EXPOSE 3001
EXPOSE 9100
EXPOSE 12798

# Set cardano-node as the entrypoint and by default just print the version.
ENTRYPOINT ["gocnode"]
CMD ["--id","0" ]

