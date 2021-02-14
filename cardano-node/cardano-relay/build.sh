#!/bin/bash


set -o errexit
set -o nounset

echo "Provided arguments: $@"

# Current version
BASE_VERSION=$(cat ../cardano-base-bin/version)
IMAGE_BASE="adakailabs/cardano-base-bin:${BASE_VERSION}"
VERSION=$(cat version)
IMAGE="adakailabs/cardano-relay:${VERSION}"

echo "cardano relay image: ${IMAGE_BASE}"

docker login 

docker build  \
       --file Dockerfile \
       --build-arg CARDANO_NODE_BASE=${IMAGE_BASE} \
       -t ${IMAGE} .
docker push ${IMAGE}


