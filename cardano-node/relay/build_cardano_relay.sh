#!/bin/bash

set -o errexit
set -o nounset

./build_cardano_base.sh

# Current version
BASE_VERSION=$(cat cardano_base_version)
IMAGE_BASE="adakailabs/cardano-base:${BASE_VERSION}"
VERSION=$(cat cardano_relay_version)
IMAGE="adakailabs/cardano-relay:${VERSION}"

echo "cardano node base image: ${IMAGE_BASE}"

docker login 
docker build  --file Dockerfile.cardano-relay --build-arg CARDANO_NODE_BASE=${IMAGE_BASE} -t ${IMAGE} .
docker push ${IMAGE}

# Current version
