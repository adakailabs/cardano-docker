#!/bin/bash

set -e 

CARDANO_VERSION=1.25.0
CARDANO_BUILD=5544808
mkdir -p ./ctmp \
    && cd ctmp \
    && mkdir -p /etc/cardano/ \
    && mkdir -p /opt/bin \
    && wget https://hydra.iohk.io/build/$CARDANO_BUILD/download/1/cardano-node-${CARDANO_VERSION}-linux.tar.gz \
    && tar -xvzf cardano-node-${CARDANO_VERSION}-linux.tar.gz \
    && rm cardano-node-${CARDANO_VERSION}-linux.tar.gz \
    && mv configuration /etc/cardano/ \
    && mv * /opt/bin/ \
    && cd .. && rm -rf ctmp 	  

echo "done installing cardano" 
