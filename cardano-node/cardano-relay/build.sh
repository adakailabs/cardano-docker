#!/bin/bash


set -o errexit
set -o nounset

echo "Provided arguments: $@"

# Current version
BASE_VERSION=$(cat ../cardano-base/version)
IMAGE_BASE="adakailabs/cardano-base:multi_${BASE_VERSION}"
VERSION=$(cat version)
IMAGE="adakailabs/cardano-relay:multi_${VERSION}"

echo "cardano relay image: ${IMAGE_BASE}"

MACHINE_TYPE=`uname -m`

if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    ARCH="linux/amd64"
    BUILDX_URI="https://github.com/docker/buildx/releases/download/v0.5.1/buildx-v0.5.1.linux-amd64"
else
    ARCH="linux/arm64/v8"
    BUILDX_URI="https://github.com/docker/buildx/releases/download/v0.5.1/buildx-v0.5.1.linux-arm64"
fi

BUILDX_FILE=FILE=~/.docker/cli-plugins/docker-buildx

FILE=/etc/resolv.conf
if [ -f "${BUILDX_FILE}" ]; then
    echo "found ${BUILDX_FILE}"
else 
    echo "${BUILDX_FILE} not found downloading"
    mkdir -p ~/.docker/cli-plugins
    wget -O ~/.docker/cli-plugins/docker-buildx  ${BUILDX_URI}
    chmod a+x ~/.docker/cli-plugins/docker-buildx
fi

docker login 

# docker build  \
#        --file Dockerfile \
#        --build-arg CARDANO_NODE_BASE=${IMAGE_BASE} \
#        -t ${IMAGE} .

docker buildx build --build-arg TAG=${VERSION} --file Dockerfile  \
       --push \
       --platform ${ARCH} \
       --tag ${IMAGE} .

#docker push ${IMAGE}


