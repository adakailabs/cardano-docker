#!/bin/bash

set -e

# FILES=( testnet-config.json \
# 	   testnet-byron-genesis.json \
# 	   testnet-shelley-genesis.json \
# 	   testnet-topology.json \
# 	   mainnet-config.json \
# 	   mainnet-byron-genesis.json  \
# 	   mainnet-shelley-genesis.json \ mainnet-topology.json )


CARDANO_PORT="3001"

mkdir -p $CONFIG_DST

THIS_PORT=$ID

ZERO=0
if [ $ID -eq $ZERO ];then
    OTHER_PORT=1
else
    OTHER_PORT=0
fi

    TOPOLOGY_EXTRA_THIS="
{	
\"addr\": \"$RELAY_THIS_PUBLIC_ADDR\",
\"port\": 300${THIS_PORT},
\"valency\": 1    
}"	

    TOPOLOGY_EXTRA_OTHER="
{	
\"addr\": \"$RELAY_OTHER_PUBLIC_ADDR\",
\"port\": 300${OTHER_PORT},
\"valency\": 1    
}"	

    TOPOLOGY_EXTRA='
{   	
	"addr": "relays.stakepool247.eu",
    	"port": 3001,
	"valency": 1        
}'	
    
#CONFIGS=(testnet-topology.json \
#	     mainnet-topology.json)

i=mainnet-topology.json

if [[ $NETWORK == "testnet" ]];then 
    i=testnet-topology.json 
fi
    
if [[ $TYPE == $PRODUCER_TYPE ]];then
	
    jq ".Producers[0]  = $TOPOLOGY_EXTRA_THIS"   $CONFIG_ETC/$i   > $CONFIG_DST/$i
    
    cp $CONFIG_DST/$i /tmp/$i
    
    jq ".Producers[1] |= . + $TOPOLOGY_EXTRA_OTHER"   /tmp/$i   > $CONFIG_DST/$i
    
    rm /tmp/$i
    
else
    if [[ $i == "mainnet-topology.json" ]];then
    	jq ".Producers[1] |= . + $TOPOLOGY_EXTRA"   $CONFIG_ETC/$i   > $CONFIG_DST/$i
    else
	cp  $CONFIG_ETC/$i $CONFIG_DST/$i
    fi
fi
echo "hacking topology file: $CONFIG_DST/$i"


    







