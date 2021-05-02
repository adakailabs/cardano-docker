#!/bin/bash

set -o errexit
set -o nounset

# Current version
VERSION=$(cat version)
IMAGE="adakailabs/multi_ubuntu_base:${VERSION}"

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
fi

#docker buildx create --use
#docker run --rm --privileged docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3

echo "TAG: --tag ${IMAGE}"

docker login 

docker buildx build  \
       --push \
       --platform linux/amd64,linux/arm64 \
       --tag ${IMAGE} .


