#!/bin/bash

set -e

DOWNLOAD_URL=https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1
CONFIG_TMP=/tmp/cardano-config
CONFIG_ETC=/etc/cardano/config

rm -rf $CONFIG_TMP
mkdir -p $CONFIG_TMP
mkdir -p /etc/cardano/config

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
    cp * $CONFIG_ETC
done




