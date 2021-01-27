#!/bin/bash


set -o errexit
set -o nounset


if [ $1 == "" ]; then
    echo "WARN: prometheus port not specified, using default"
    PROMETHEUS_NODE_EXPORT_PORT="9100"
fi

PROMETHEUS_NODE_EXPORT_PORT=$1

if [ $2 == "" ]; then
    echo "WARN: rt-view port not specified, using default"
    RT_VIEW_PORT="6660"
fi

RT_VIEW_PORT=$2


echo "Provided arguments: $@"

#
#
rm -rf config_tmp
cp -r  config config_tmp
sed -i "s/{{rtk-view-port}}/${RT_VIEW_PORT}/" config_tmp/config.json

# Entrypoint file
cat > entrypoint.sh <<- EOM
#!/bin/bash
set -e

# Start prometheus monitoring in the background
echo "Starting node_exporter..."
nohup node_exporter --web.listen-address=":${PROMETHEUS_NODE_EXPORT_PORT}" &

# Start cardano-node, passing all CMD args to it
echo "Starting cardano-node with arguments:"
cardano-node run \
--database-path /home/lovelace/cardano-node/db/ \
--socket-path /home/lovelace/cardano-node/db/node.socket \
--port 3001 \
--host-addr 0.0.0.0 \
--config /etc/cardano/config/config.json \
--topology /etc/cardano/config/topology.json

EOM

# Current version
BASE_VERSION=$(cat ../cardano-base/version)
IMAGE_BASE="adakailabs/cardano-base:${BASE_VERSION}"
VERSION=$(cat version)
IMAGE="adakailabs/cardano-relay:${VERSION}"

echo "cardano relay image: ${IMAGE_BASE}"

docker login 

docker build  \
       --file Dockerfile \
       --build-arg CARDANO_NODE_BASE=${IMAGE_BASE} \
       --build-arg PROMETHEUS_NODE_EXPORT_PORT=${PROMETHEUS_NODE_EXPORT_PORT} \
       -t ${IMAGE} .

rm -rf config_tmp
docker push ${IMAGE}


