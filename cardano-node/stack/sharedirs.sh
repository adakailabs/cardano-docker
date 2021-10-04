#!/bin/bash

set -e 
set -o errexit
set -o nounset

sudo mkdir -p /mnt/cardano_shares/local/redis/config \
     /mnt/cardano_shares/local/redis/lib \
     /mnt/cardano_shares/local/redis/data \
     /mnt/cardano_shares/local/redis/log \
     /mnt/cardano_shares/local/telegraf \
     /mnt/cardano_shares/local/grafana/lib \
     /home/lovelace/cardano-node

sudo chown -R galuisal:galuisal /mnt/cardano_shares/local /home/lovelace 
     
     
   
     
     
