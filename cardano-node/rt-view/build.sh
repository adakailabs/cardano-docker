#!/bin/bash

set -o errexit
set -o nounset

# Current version
BASE_VERSION=$(cat ../cardano-base/version)
IMAGE_BASE="adakailabs/multi_cardano_base:${BASE_VERSION}"
VERSION=$(cat version)
IMAGE="adakailabs/cardano-monitor:${VERSION}"

echo "building cardano image: ${IMAGE_BASE}"

make -C ../gocnode gocnode
mkdir -p tmp/ 
cp ../gocnode/gocnode_amd64 tmp/gocnode

docker login 
docker build  --file Dockerfile --build-arg CARDANO_NODE_BASE=${IMAGE_BASE} -t ${IMAGE} .
docker push ${IMAGE}
rm -rf tmp
