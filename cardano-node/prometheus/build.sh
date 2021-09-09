#!/bin/bash

set -o errexit
set -o nounset
#multi_ubuntu_base
# Current version
VERSION=$(cat version)
IMAGE="adakailabs/multi_prometheus:${VERSION}"

echo "prometheus image: ${IMAGE}"

make -C ../gocnode VERSION=${VERSION} gocnode
mkdir -p tmp/ 
cp ../gocnode/gocnode_* tmp/

docker system prune --force
docker image prune -f
docker container prune -f

docker login 


#docker buildx rm  cardano
#docker buildx create --platform amd64 --name cardano --use 
#docker buildx create --platform arm64 --name cardano --append ssh://lovelace@192.168.100.40:2222



#docker build --tag ${IMAGE} .

docker buildx build --builder cardano --build-arg TAG=${VERSION}   \
       --push \
       --platform linux/arm64 \
       --tag ${IMAGE} .

rm -rf tmp

       #       --platform linux/amd64,linux/arm64 \
