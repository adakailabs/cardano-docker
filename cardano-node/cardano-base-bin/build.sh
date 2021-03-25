#!/bin/bash

set -o errexit
set -o nounset

# Current version
VERSION=$(cat version)
IMAGE="adakailabs/cardano-base-bin:${VERSION}"

docker login 
docker build --build-arg CARDANO_VERSION=${VERSION} --file Dockerfile -t ${IMAGE} .
docker push ${IMAGE}
