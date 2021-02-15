#!/bin/bash
IMAGE=adakailabs/cardano-relay:latest
docker pull $IMAGE
docker run --mount type=bind,src="/home/lovelace/cardano-node",target="/home/lovelace/cardano-node" \
       $IMAGE --standalone --testnet
