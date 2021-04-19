#!/bin/bash


set -o errexit
set -o nounset

echo "Provided arguments: $@"

# Current version
BASE_VERSION=$(cat ../cardano-base/version)
IMAGE_BASE="adakailabs/cardano-base:${BASE_VERSION}"
VERSION=$(cat version)
IMAGE="adakailabs/cardano-pool:${VERSION}"

echo "cardano relay image: ${IMAGE_BASE}"

make -C ../gocnode gocnode
mkdir -p tmp/ 
cp ../gocnode/gocnode tmp/


docker build  \
       --file Dockerfile \
       --build-arg CARDANO_NODE_BASE=${IMAGE_BASE} \
       -t ${IMAGE} .

docker login 
docker push ${IMAGE}

rm -rf tmp

