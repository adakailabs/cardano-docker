#!/bin/bash

docker service rm cardano_monitor cardano_relay0 cardano_relay1 cardano_producer0 cardano_producer1 cardano_grafana cardano_prometheus cardano_redis cardano_optimizer

docker secret rm cardano_grafana_admin_password \
       cardano_node_kes.key \
       cardano_node.cert \
       cardano_node_vrf.key \
       cardano_gocnode.yaml 
 
docker service ls

docker secret ls 
