#!/usr/bin/bash

set -o errexit
set -o nounset

# Current version
VERSION=$(cat cardano_base_version)
IMAGE="adakailabs/cardano-base:${VERSION}"

docker login 
docker build -t ${IMAGE} --file Dockerfile.cardano-base
docker push ${IMAGE}

# Current version
