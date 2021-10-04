#!/bin/bash

set -e 
set -o errexit
set -o nounset

CARDANO_REALY_VERSION=$(cat ../cardano-pool/version)
PROMETHEUS_VERSION=$(cat ../prometheus/version)
CARDANO_RT_VIEW_VERSION=$(cat ../rt-view/version)

docker stack deploy -c local-pool.yaml cardano
