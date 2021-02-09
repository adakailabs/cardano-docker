#!/bin/bash

set -e 

scp -P 6666 secrets/* lovelace@master01.adakailabs.com:/home/lovelace/cardano-docker/cardano-node/stack/secrets
#scp -P 2222 secrets/* lovelace@master00.adakailabs.com:/home/lovelace/cardano-docker/cardano-node/stack/secrets
