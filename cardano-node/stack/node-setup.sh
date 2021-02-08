#!/bin/bash

#docker node update --label-add com.adakailabs.monitor=true adakai-swarm00
#docker node update --label-add com.adakailabs.relay0=true adakai-swarm01
#docker node update --label-add com.adakailabs.relay1=true adakai-swarm01
#docker node update --label-add com.adakailabs.producer0=true adakai-swarm02

docker node update --label-add com.adakailabs.monitor=true master00
docker node update --label-add com.adakailabs.relay0=true relay00
docker node update --label-add com.adakailabs.relay1=true relay01
docker node update --label-add com.adakailabs.producer0=true producer00
