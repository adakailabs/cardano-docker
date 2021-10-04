#!/bin/bash

set -e 
set -o errexit
set -o nounset

CARDANO_REALY_VERSION=$(cat ../cardano-pool/version)
PROMETHEUS_VERSION=$(cat ../prometheus/version)
CARDANO_RT_VIEW_VERSION=$(cat ../rt-view/version)

# docker pull "adakailabs/cardano-relay:$CARDANO_REALY_VERSION"
# docker pull "adakailabs/cardano-monitor:$CARDANO_RT_VIEW_VERSION"
# docker pull "adakailabs/cardano-prometheus:$PROMETHEUS_VERSION"

mkdir -p /home/lovelace/prometheus

docker stack deploy -c mainnet-pool.yaml cardano
