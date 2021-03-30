#!/bin/bash

set -e 


master00_ip="10.116.0.2"
relay00_ip="10.116.0.3"
relay01_ip="10.116.0.5"
producer_ip="10.116.0.4"

master00_ip2="206.189.201.90"
relay00_ip2="167.99.239.161"
relay01_ip2="104.248.239.167"
producer_ip2="206.189.191.231"


hosts=($master00_ip $relay00_ip $relay01_ip $producer_ip $master00_ip2 $relay00_ip2 $relay01_ip2 $producer_ip2)

docker node update --label-add com.adakailabs.monitor=true master00
docker node update --label-add com.adakailabs.relay0=true relay00
docker node update --label-add com.adakailabs.relay1=true relay01
docker node update --label-add com.adakailabs.producer0=true producer00
