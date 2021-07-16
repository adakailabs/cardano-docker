#!/bin/bash

set -e 


#docker node update --label-add com.adakailabs.monitor=true roci-master00
#docker node update --label-add com.adakailabs.relay0=true roci-relay00
docker node update --label-add com.adakailabs.relay1=true raspberry4
#docker node update --label-add com.adakailabs.producer0=true roci-producer00

