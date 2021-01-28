ARG CARDANO_NODE_BASE=adakailabs/cardano-base:latest
FROM $CARDANO_NODE_BASE AS build
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

RUN mkdir -p /etc/cardano

# Build the final stage and copy the build artifacts from the previous stage.
FROM adakailabs/ubuntu-base:latest
COPY --from=build /usr/local/rt-view /usr/local/rt-view

ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Copy over other resources from the build context.
COPY rt-view-config /etc/cardano/rt-view

COPY entrypoint.sh /usr/local/bin/


# Expose prometheus monitoring ports

USER lovelace

# Set cardano-node as the entrypoint and by default just print the version.
ENTRYPOINT ["entrypoint.sh"]
CMD ["--version"]
