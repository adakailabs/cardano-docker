#!/bin/bash
#set -x
set -e
set +u 

NAME="relay"
ID="0"

if [ -z $1  ]; then
    echo "WARN: using default type: producer"
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

BASE_PATH="/home/lovelace/cardano-node/${NAME}"
TOPOLOGY=$BASE_PATH/config/topology.json
CONFIG=$BASE_PATH/config/config.json

mkdir -p $BASE_PATH/secrets 
mkdir -p $BASE_PATH/config

CONFIG_DIR=$BASE_PATH/config
GENESIS1=$CONFIG_DIR/$ERA1_JSON
GENESIS2=$CONFIG_DIR/$ERA2_JSON

PROMETHEUS_PORT="12798"
CARDANO_PORT="3001"
PROMETHEUS_NODE_EXPORT_PORT="9100"

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
nohup node_exporter --web.listen-address=":${PROMETHEUS_NODE_EXPORT_PORT}" &


if [ -f "$CONFIG" ]; then
    echo "$CONFIG found, copying from /etc/cardano-node"
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


secrets_path="/run/secrets"
shelley_kes_key_file="$secrets_path/kes_key.skey"
shelley_vrf_key_file="$secrets_path/vrf_skey.skey"
shelley_operational_certificate_file="$secrets_path/operational_certificate.cert"


database_path="--database-path $BASE_PATH/db/"
socket_path="--socket-path $BASE_PATH/db/node.socket"
port="--port $CARDANO_PORT "
host_address="--host-addr 0.0.0.0"
config="--config $CONFIG"
topology="--topology $TOPOLOGY"
shelley_kes_key="--shelley-kes-key $shelley_kes_key_file"
shelley_vrf_key="--shelley-vrf-key $shelley_vrf_key_file"
shelley_operational_certificate="--shelley-operational-certificate $shelley_operational_certificate_file"

echo "
--------------------------------------------------------------------------
database_path                   : $database_path
socket_path                     : $socket_path
port                            : $port          
host_address                    : $host_address
config                          : $config
topology                        : $topology"
set +u 
if [ -z $3  ]; then
echo "shelley_kes_key                 : $shelley_kes_key
shelley-vrf-key                 : $shelley_vrf_key
shelley_operational_certificate : $shelley_operational_certificate
--------------------------------------------------------------------------"

cmd_args="$database_path $socket_path $port $host_address $config $topology $shelley_kes_key $shelley_vrf_key $shelley_operational_certificate"

else
cmd_args="$database_path $socket_path $port $host_address $config $topology"    
fi     
set -u

ls -rtl $secrets_path

cardano-node run $cmd_args 


