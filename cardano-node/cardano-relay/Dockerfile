ARG CARDANO_NODE_BASE=adakailabs/cardano-base:latest
FROM $CARDANO_NODE_BASE AS build
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

# Build the final stage and copy the build artifacts from the previous stage.
FROM adakailabs/ubuntu-base:latest
COPY --from=build /usr/local/lib/libsodium* /usr/local/lib/
COPY --from=build /opt/bin/cardano-cli /usr/local/bin/
COPY --from=build /opt/bin/cardano-node /usr/local/bin/
COPY --from=build /usr/local/bin/node_exporter /usr/local/bin

ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Copy over other resources from the build context.
COPY config /etc/cardano/config

COPY entrypoint.sh /usr/local/bin/

# Expose prometheus monitoring ports
USER lovelace

# Set cardano-node as the entrypoint and by default just print the version.
ENTRYPOINT ["entrypoint.sh"]
CMD ["--version"]
