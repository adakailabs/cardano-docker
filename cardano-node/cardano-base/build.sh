#!/bin/bash

set -e 
#set -o errexit
#set -o nounset

# Current version
VERSION=$(cat version)
IMAGE="adakailabs/multi_cardano_base:${VERSION}"

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
#    docker run --rm --privileged docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3
fi

#docker buildx rm  cardano
#docker buildx create --platform amd64 --name cardano --use 
#docker buildx create --platform arm64 --name cardano --append ssh://lovelace@192.168.100.40:2222

#cd cardano-base-pkgs      && ./build.sh && cd ..
#cd cardano-base-libsodium && ./build.sh && cd ..
#cd cardano-base-ghs       && ./build.sh && cd ..
#cd cardano-base-cabal     && ./build.sh && cd ..
#cd cardano-base-exporter  && ./build.sh && cd ..

docker login 

docker buildx build --builder cardano --build-arg TAG=${VERSION}  \
       --push \
       --platform linux/amd64,linux/arm64 \
       --tag ${IMAGE} .

docker build --build-arg TAG=${VERSION} --tag ${IMAGE} . 



