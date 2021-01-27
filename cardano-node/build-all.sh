#!/bin/bash
cd cardano-base
./build.sh
cd ../cardano-relay 
./build.sh &&

# create image that will support 2 relays and 1 producer
cd ../cardano-monitor
./build.sh && cd ..
