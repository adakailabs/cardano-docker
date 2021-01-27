#!/bin/bash

set -o errexit
set -o nounset

docker pull adakailabs/cardano-relay:21.01.00
docker pull adakailabs/cardano-monitor:21.01.02

docker stack deploy -c node-stack.yaml cardano
