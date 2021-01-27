#!/bin/bash

cd cardano-base  && ./build.sh 
cd cardano-relay && ./build.sh 9100 6660
cd cardano-monitor && ./build.sh 2 
