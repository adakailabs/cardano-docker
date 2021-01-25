#!/bin/bash

set -o errexit
set -o nounset

docker stack deploy -c node-stack.yaml cardano-node
