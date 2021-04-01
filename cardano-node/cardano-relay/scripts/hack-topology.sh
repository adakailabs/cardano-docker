#!/bin/bash

set -e


CARDANO_PORT="3001"

mkdir -p $CONFIG_DST

THIS_PORT=$ID

ZERO=0
if [ $ID -eq $ZERO ];then
    OTHER_PORT=1
else
    OTHER_PORT=0
fi

if [[ $TYPE == $PRODUCER_TYPE ]];then
    echo "this is a producer" 
else
    echo "this is a relay"
    sleep 10
fi

producer_ip=$(nslookup producer0 | grep Address: | grep -v \# | grep -v "::" | sed 's/Address: //g')

echo $test

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

#     TOPOLOGY_EXTRA_THIS="
# {	
# \"addr\": \"$RELAY_THIS_PRIVATE_ADDR\",
# \"port\": 3001,
# \"valency\": 1    
# }"	

#     TOPOLOGY_EXTRA_OTHER="
# {	
# \"addr\": \"$RELAY_OTHER_PRIVATE_ADDR\",
# \"port\": 3001,
# \"valency\": 1    
# }"	


    TOPOLOGY_PRODUCER="
{	
\"addr\": \"$producer_ip\",
\"port\": 3001,
\"valency\": 1    
}"	

    # https://explorer.cardano.org/relays/topology.json
    
    TOPOLOGY_EXTRA_MAINNET1='
{   	
	"addr": "54.220.20.40",
    	"port": 3002,
	"valency": 1        
}'

    TOPOLOGY_EXTRA_MAINNET2='
{   	
	"addr": "95.217.220.249",
    	"port": 6060,
	"valency": 1        
}'

    TOPOLOGY_EXTRA_MAINNET3='
{   	
	"addr": "3.129.162.200",
    	"port": 3013,
	"valency": 1        
}'

    TOPOLOGY_EXTRA_MAINNET4='
{   	
	"addr": "14.201.73.146",
    	"port": 3001,
	"valency": 1        
}'
    
    
    # https://explorer.cardano-testnet.iohkdev.io/relays/topology.json

    TOPOLOGY_EXTRA_TESTNET1='
{   	
      	"addr": "t.uniquestaking.com",
      	"port": 3001,
      	"continent": "North America",
      	"state": "Iowa",
	"valency": 1    
}'	

    TOPOLOGY_EXTRA_TESTNET2='
{   	
	"addr": "relays.testnet.stakenuts.com",
      	"port": 3001,
      	"continent": "North America",
      	"state": "New Jersey",
	"valency": 1    
}'	

    TOPOLOGY_EXTRA_TESTNET3='
{   	
	 "addr": "testnet.adanorthpool.com",
      	 "port": 9015,
      	 "continent": "Europe",
      	 "state": "NO",
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
    	jq ".Producers[1] |= . + $TOPOLOGY_EXTRA_MAINNET1"   $CONFIG_ETC/$i   > $CONFIG_DST/$i

	cp $CONFIG_DST/$i /tmp/$i

	jq ".Producers[2] |= . + $TOPOLOGY_EXTRA_MAINNET2"   /tmp/$i   > $CONFIG_DST/$i

	#cp $CONFIG_DST/$i /tmp/$i

	#jq ".Producers[3] |= . + $TOPOLOGY_EXTRA_MAINNET3"   /tmp/$i   > $CONFIG_DST/$i

	#cp $CONFIG_DST/$i /tmp/$i

	#jq ".Producers[4] |= . + $TOPOLOGY_EXTRA_MAINNET4"   /tmp/$i   > $CONFIG_DST/$i

	#cp $CONFIG_DST/$i /tmp/$i

	#jq ".Producers[5] |= . + $TOPOLOGY_EXTRA_MAINNET5"   /tmp/$i   > $CONFIG_DST/$i

	cp $CONFIG_DST/$i /tmp/$i

	jq ".Producers[3] |= . + $TOPOLOGY_PRODUCER"   /tmp/$i   > $CONFIG_DST/$i
	
    else
	jq ".Producers[1] |= . + $TOPOLOGY_EXTRA_TESTNET1"   $CONFIG_ETC/$i   > $CONFIG_DST/$i

        cp $CONFIG_DST/$i /tmp/$i

        jq ".Producers[2] |= . + $TOPOLOGY_EXTRA_TESTNET2"   /tmp/$i   > $CONFIG_DST/$i
	
        cp $CONFIG_DST/$i /tmp/$i

        jq ".Producers[3] |= . + $TOPOLOGY_EXTRA_TESTNET3"   /tmp/$i   > $CONFIG_DST/$i

	cp $CONFIG_DST/$i /tmp/$i

        jq ".Producers[4] |= . + $TOPOLOGY_PRODUCER"   /tmp/$i   > $CONFIG_DST/$i
	
    fi
fi
echo "hacking topology file: $CONFIG_DST/$i"


    







