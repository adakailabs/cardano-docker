#!/bin/bash

set -e

echo "HERE: $PWD"

NAME="relay0"
DOWNLOAD_URL=https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1
CARDANO_NODE_PATH=/home/lovelace/cardano-node/${NAME}/
CONFIG_TMP=/tmp/cardano-config
CONFIG_ETC=$CONFIG_TMP/
CONFIG_DST=$PWD/config
CONFIG_NAME=mainnet-config.json
CONFIG_NEW=mainnet-config-new.json
CONFIG_ORIG="${CONFIG_TMP}/$CONFIG_NAME"

PROMETHEUS_PORT="66666"
DEFAULT_SCRIBES="[[\"StdoutSK\",\"stdout\"],[\"FileSK\",\"/home/lovelace/cardano-node/${NAME}/log/${NAME}.log\"]]"
HAS_PROMETHEUS="[\"0.0.0.0\",\"${PROMETHEUS_PORT}\"]"

rm -rf $CONFIG_TMP

mkdir -p $CONFIG_TMP

FILES=( testnet-config.json \
	   testnet-byron-genesis.json \
	   testnet-shelley-genesis.json \
	   testnet-topology.json \
	   mainnet-config.json \
	   mainnet-byron-genesis.json  \
	   mainnet-shelley-genesis.json \ mainnet-topology.json )

cd $CONFIG_TMP
for i in ${FILES[@]}; do
    wget $DOWNLOAD_URL/$i
done


CONFIGS=(testnet-config.json \
	     mainnet-config.json)

for i in ${CONFIGS[@]}; do
    jq '.TraceBlockFetchDecisions = true' $CONFIG_TMP/$i > $CONFIG_DST/$i
    jq ".defaultScribes = $DEFAULT_SCRIBES" $CONFIG_TMP/$i > $CONFIG_DST/$i
    jq ".hasPrometheus = $HAS_PROMETHEUS" $CONFIG_TMP/$i > $CONFIG_DST/$i
done



