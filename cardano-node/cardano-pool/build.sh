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

#go install -v  github.com/adakailabs/gocnode@latest

#cp ~/go/bin/gocnode . 
cp ../gocnode . 

docker login 

docker build  \
       --file Dockerfile \
       --build-arg CARDANO_NODE_BASE=${IMAGE_BASE} \
       -t ${IMAGE} .
docker push ${IMAGE}


