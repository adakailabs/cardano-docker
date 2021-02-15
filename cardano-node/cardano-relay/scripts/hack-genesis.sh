#!/bin/bash

set -e

mkdir -p $CONFIG_DST

i=${NETWORK}-byron-genesis.json
j=${NETWORK}-shelley-genesis.json

cp $CONFIG_ETC/$i   $CONFIG_DST/$i
cp $CONFIG_ETC/$j   $CONFIG_DST/$j 
    
echo "hacking genesis file: $CONFIG_DST/$i"
echo "hacking genesis file: $CONFIG_DST/$j"


