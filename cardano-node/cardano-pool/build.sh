#!/bin/bash


set -o errexit
set -o nounset

echo "Provided arguments: $@"

# Current version
BASE_VERSION=$(cat cardano_base_version)
VERSION=$(cat version)
IMAGE="adakailabs/multi_cardano_pool:${VERSION}"

#echo "cardano relay image: ${IMAGE_BASE}"
echo "building version: ${VERSION}"

MACHINE_TYPE=`uname -m`

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

make -C ../gocnode VERSION=${VERSION} gocnode
mkdir -p tmp/ 
cp ../gocnode/gocnode_* tmp/

docker system prune --force
docker image prune -f
docker container prune -f
#docker buildx rm remote 

#docker buildx create --use
#docker run --rm --privileged docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3
#docker buildx create --name remote --append ssh://lovelace@192.168.100.40:2222

docker login 

docker buildx build  \
       --push \
       --platform linux/amd64,linux/arm64 \
       --tag ${IMAGE} .

rm -rf tmp

