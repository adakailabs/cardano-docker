#!/bin/bash

set -e
export NAME
export TYPE="relay"
export PRODUCER_TYPE="producer"
export ID=0
export NETWORK=mainnet
export ERA1=shelley
export ERA2=byron
export PROMETHEUS_PORT="66666"
export CARDANO_PORT="3001"
export PROMETHEUS_NODE_EXPORT_PORT="9100"
export SECRETS_PATH=../secrets

export ERA1_JSON=${NETWORK}-${ERA1}-genesis.json
export ERA2_JSON=${NETWORK}-${ERA2}-genesis.json

export PRODUCER0_ADDR
export RELAY_THIS_PUBLIC_ADDR
export RELAY_OTHER_PUBLIC_ADDR
export RELAY_THIS_PRIVATE_ADDR
export RELAY_OTHER_PRIVATE_ADDR


if [[ $TYPE == $PRODUCER_TYPE ]];then
    NAME=$TYPE
else
    NAME="${TYPE}${ID}"
fi    


export CARDANO_BASE_DIR=/home/lovelace/cardano-node/${NETWORK}/${NAME}
export CARDANO_CONFIG_DIR=$CARDANO_BASE_DIR/config

mkdir -p $CARDANO_CONFIG_DIR

export CONFIG_ETC=/etc/cardano/config
export CONFIG_DST=$CARDANO_CONFIG_DIR
export CONFIG_NAME=${NETWORK}-config.json
export CONFIG_NEW=${NETWORK}-config-new.json


export RT_VIEW_PORT

if [[ $TYPE == $PRODUCER_TYPE ]];then
    RT_VIEW_PORT="6602"
else
    RT_VIEW_PORT=$(printf '66%02d' "${ID}")
fi    


./hack-config.sh 

source ./hack-secrets.sh

./hack-topology.sh

./hack-genesis.sh 

echo "
-----------------------------------------------
Node Name           : $NAME
Node Exporter Port  : $PROMETHEUS_NODE_EXPORT_PORT
Prometheus Port     : $PROMETHEUS_PORT
RT View Port        : $RT_VIEW_PORT
Cardano Port        : $CARDANO_PORT
Producer Addr       : $PRODUCER0_ADDR
Relay This Public   : $RELAY_THIS_PUBLIC_ADDR
Relay Other Public  : $RELAY_OTHER_PUBLIC_ADDR
Relay This Private  : $RELAY_THIS_PRIVATE_ADDR
Relay Other Private : $RELAY_OTHER_PRIVATE_ADDR
-----------------------------------------------
"
