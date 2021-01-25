#!/bin/bash

set -o errexit
set -o nounset

# Current version
VERSION=$(cat cardano_base_version)
IMAGE="adakailabs/cardano-base:${VERSION}"

docker login 
docker build --file Dockerfile.cardano-base -t ${IMAGE} .
docker push ${IMAGE}

# Current version
