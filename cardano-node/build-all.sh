#!/bin/bash

cd cardano-base  && ./build.sh 
cd cardano-relay && ./build.sh 9100 6660
