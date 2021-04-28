#!/bin/bash

docker service rm cardano_monitor cardano_relay0 cardano_producer0

docker service ls

docker secret ls 
