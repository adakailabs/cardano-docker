#!/bin/bash

set -o errexit
set -o nounset


cd cardano-base
./build.sh
cd ../cardano-relay 
./build.sh &&

# create image that will support 2 relays and 1 producer
cd ../rt-view

./build.sh &&

cd ../prometheus
./build.sh && cd ..
