#!/bin/bash

set -e 

docker node update --label-add com.adakailabs.monitor=true adakai-swarm00
docker node update --label-add com.adakailabs.relay0=true adakai-swarm01
docker node update --label-add com.adakailabs.relay1=true adakai-swarm02
docker node update --label-add com.adakailabs.producer0=true adakai-swarm03
docker node update --label-add com.adakailabs.relay3=true adakai-swarm04

