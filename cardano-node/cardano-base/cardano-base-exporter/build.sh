#!/bin/bash

set -o errexit
set -o nounset

# Current version
VERSION=$(cat version)
IMAGE="adakailabs/multi_cardano_base_exporter:${VERSION}"

echo "version: ${VERSION}"

MACHINE_TYPE=`uname -m`

ARCH="linux/amd64,linux/arm64"

if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    BUILDX_URI="https://github.com/docker/buildx/releases/download/v0.5.1/buildx-v0.5.1.linux-amd64"
else
    BUILDX_URI="https://github.com/docker/buildx/releases/download/v0.5.1/buildx-v0.5.1.linux-arm64"
fi

BUILDX_FILE=~/.docker/cli-plugins/docker-buildx

if [ -f "${BUILDX_FILE}" ]; then
    echo "found ${BUILDX_FILE}"
else 
    echo "${BUILDX_FILE} not found downloading"
    mkdir -p ~/.docker/cli-plugins
    wget -O ~/.docker/cli-plugins/docker-buildx  ${BUILDX_URI}
    chmod a+x ~/.docker/cli-plugins/docker-buildx
    docker buildx create --use

fi

#docker buildx rm  cardano
#docker buildx create --platform amd64 --name cardano --use 
#docker buildx create --platform arm64 --name cardano --append ssh://lovelace@192.168.100.40:2222

docker login 


docker buildx build  \
       --builder cardano \
       --push \
       --platform linux/amd64,linux/arm64 \
       --tag ${IMAGE} .


#docker build --build-arg TAG=${VERSION} --tag ${IMAGE} .  



