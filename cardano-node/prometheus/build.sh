#!/bin/bash

set -o errexit
set -o nounset

# Current version
VERSION=$(cat version)
IMAGE="adakailabs/cardano-prometheus:${VERSION}"

echo "prometheus image: ${IMAGE}"

docker login 
docker build  --file Dockerfile -t ${IMAGE}  . 
docker push ${IMAGE}

