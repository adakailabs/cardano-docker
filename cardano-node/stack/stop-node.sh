#!/bin/bash

docker service rm cardano_relay0 cardano_relay1 cardano_producer0

docker service ls

docker secret ls 
