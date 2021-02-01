#!/bin/bash

set -o errexit
set -o nounset

cd ubuntu-base
./build.sh

cd ../cardano-base
./build.sh

cd ../cardano-relay 
./build.sh &&

cd ../rt-view
./build.sh &&

cd ../prometheus
./build.sh && cd ..
