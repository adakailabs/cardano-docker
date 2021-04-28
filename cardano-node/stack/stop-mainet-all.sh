#!/bin/bash

docker service rm cardano_grafana cardano_monitor cardano_prometheus cardano_relay0 cardano_relay1 cardano_producer0

docker secret rm cardano_grafana_admin_password \
       cardano_node_kes.key \
       cardano_node.cert \
       cardano_node_vrf.key \
       cardano_gocnode.yaml 

docker service ls

docker secret ls 
