#!/bin/bash

set -o errexit
set -o nounset

# Current version
VERSION=$(cat version)
IMAGE="adakailabs/cardano-base:${VERSION}"

docker login 
docker build --build-arg TAG=${VERSION} --file Dockerfile -t ${IMAGE} .
docker push ${IMAGE}
