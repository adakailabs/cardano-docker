#!/bin/bash
#set -x
set -e
set +u 

NAME="relay"
ID="0"

if [ -z $1  ]; then
    echo "WARN: using default type: relay"
else
    NAME=$1
fi

if [ -z $2  ]; then
    echo "WARN: using default ID: 0"
else ID=$2
fi

set -u 

ERA1=shelley
ERA2=byron

ERA1_JSON=mainnet-${ERA1}-genesis.json
ERA2_JSON=mainnet-${ERA2}-genesis.json


mkdir -p /home/lovelace/cardano-node/${NAME}/config
CONFIG_DIR=/home/lovelace/cardano-node/${NAME}/config
GENESIS1=$CONFIG_DIR/$ERA1_JSON
GENESIS2=$CONFIG_DIR/$ERA2_JSON
CONFIG=/home/lovelace/cardano-node/${NAME}/config/config.json
TOPOLOGY=/home/lovelace/cardano-node/${NAME}/config/topology.json
PROMETHEUS_PORT=$(printf '127%02d' "${ID}")
CARDANO_PORT=$(printf '31%02d' "${ID}")
PROMETHEUS_NODE_EXPORT_PORT=$(printf '91%02d' "${ID}")
RT_VIEW_PORT=$(printf '66%02d' "${ID}")


echo "
-----------------------------------------------
Node Name    : $NAME
Prom Port    : $PROMETHEUS_NODE_EXPORT_PORT
Prometh Port : $PROMETHEUS_PORT
RT View Port : $RT_VIEW_PORT
Cardano Port : $CARDANO_PORT
-----------------------------------------------
"




# Start prometheus monitoring in the background
echo "Starting node_exporter..."
nohup node_exporter --web.listen-address=":${NODE_EXPORTER_PORT}" &


if [ -f "$CONFIG" ]; then
    echo "$CONFIG found, replacing"
    cp /etc/cardano/config/config.json $CONFIG
    sed -i "s/{{node-name}}/${NAME}/g" $CONFIG
    sed -i "s/{{node-id}}/${RT_VIEW_PORT}/g" $CONFIG
    sed -i "s/{{prometheus-port}}/${PROMETHEUS_PORT}/g" $CONFIG
else 
    echo echo "$CONFIG NOT found, copying from /etc/cardano-node"
    cp /etc/cardano/config/config.json $CONFIG
    sed -i "s/{{node-name}}/${NAME}/g" $CONFIG
    sed -i "s/{{node-id}}/${RT_VIEW_PORT}/g" $CONFIG
    sed -i "s/{{prometheus-port}}/${PROMETHEUS_PORT}/g" $CONFIG
    
fi

if [ -f "$TOPOLOGY" ]; then
    echo "$TOPOLOGY found."
    cp /etc/cardano/config/topology.json $TOPOLOGY
else 
    echo echo "$TOPOLOGY NOT found, copying from /etc/cardano-node"
    cp /etc/cardano/config/topology.json $TOPOLOGY
fi

if [ -f "$GENESIS1" ]; then
    echo "$GENESIS1 found."
    cp /etc/cardano/config/$ERA1_JSON $GENESIS1
else 
    echo echo "$GENESIS1 NOT found, copying from /etc/cardano-node"
    cp /etc/cardano/config/$ERA1_JSON $GENESIS1
fi

if [ -f "$GENESIS2" ]; then
    echo "$GENESIS2 found."
    cp /etc/cardano/config/$ERA2_JSON $GENESIS2
else 
    echo echo "$GENESIS2 NOT found, copying from /etc/cardano-node"
    cp /etc/cardano/config/$ERA2_JSON $GENESIS2
fi

echo $CARDANO_PORT
echo $PROMETHEUS_PORT

cardano-node run \
		    --database-path /home/lovelace/cardano-node/${NAME}/db/ \
		    --socket-path /home/lovelace/cardano-node/${NAME}/db/node.socket \
		    --port $CARDANO_PORT --host-addr 0.0.0.0 \
		    --config $CONFIG \
		    --topology $TOPOLOGY

