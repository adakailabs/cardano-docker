#!/bin/bash

docker service rm cardano_grafana cardano_monitor cardano_prometheus cardano_relay0 cardano_relay1 cardano_producer0

docker secret rm cardano_grafana_admin_password \
       cardano_kes_key.skey \
       cardano_my_secret \
       cardano_operational_certificate.cert \
       cardano_vrf_skey.skey \
       cardano_producer_private_host_name \
       cardano_relay0_private_host_name \
       cardano_relay0_public_host_name \
       cardano_relay1_private_host_name \
       cardano_relay1_public_host_name 

docker service ls

docker secret ls 