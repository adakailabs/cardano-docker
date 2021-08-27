#!/bin/bash


#set -o errexit
#set -o nounset

#docker run --rm --privileged docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3
docker buildx rm cardano
docker buildx create --platform linux/amd64 --use --name cardano
docker buildx create --platform linux/arm64 --name cardano --append ssh://lovelace@192.168.100.40:2222

docker buildx ls

