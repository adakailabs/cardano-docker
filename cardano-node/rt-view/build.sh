#!/bin/bash

set -o errexit
set -o nounset

# Current version
BASE_VERSION=$(cat ../cardano-base/version)
IMAGE_BASE="adakailabs/cardano-base:${BASE_VERSION}"
VERSION=$(cat ../cardano-base/version)
IMAGE="adakailabs/cardano-monitor:${VERSION}"

echo "building cardano image: ${IMAGE_BASE}"

docker login 
docker build  --file Dockerfile --build-arg CARDANO_NODE_BASE=${IMAGE_BASE} -t ${IMAGE} .
rm -rf rt-view-config_tmp
docker push ${IMAGE}
