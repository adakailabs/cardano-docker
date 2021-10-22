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


make -C ../gocnode VERSION=${VERSION} gocnode
mkdir -p tmp/ 
cp ../gocnode/gocnode_* tmp/

chmod 775 ../gocnode/gocnode_amd64

GOCNODE='../gocnode/gocnode_amd64 /'

bash -c  ${GOCNODE} --help

bash -c  ${GOCNODE} start-node --help

bash -c  ${GOCNODE} start-optim --help

bash -c  ${GOCNODE} start-prometheus --help

bash -c  ${GOCNODE} start-rtview --help



 # start-node       Start a cardano node
 #  start-optim      Start a node latancy optimizer process
 #  start-prometheus Start prometheus for monitoring a cardano pool
 #  start-rtview     Start rtview for monitoring a cardano pool



rm -rf tmp

