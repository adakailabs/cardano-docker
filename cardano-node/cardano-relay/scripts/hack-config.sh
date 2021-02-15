#!/bin/bash

set -e

# FILES=( testnet-config.json \
# 	   testnet-byron-genesis.json \
# 	   testnet-shelley-genesis.json \
# 	   testnet-topology.json \
# 	   mainnet-config.json \
# 	   mainnet-byron-genesis.json  \
# 	   mainnet-shelley-genesis.json \ mainnet-topology.json )

# cd $CONFIG_TMP
# for i in ${FILES[@]}; do
#     wget $DOWNLOAD_URL/$i
# done



mkdir -p $CONFIG_DST

TRACE_FORWARD_TO="{\"tag\": \"RemoteSocket\",\"contents\": [\"monitor\",\"${RT_VIEW_PORT}\"]}"

DEFAULT_SCRIBES="[[\"StdoutSK\",\"stdout\"],[\"FileSK\",\"${CARDANO_BASE_DIR}/log/${NAME}.log\"]]"

SETUP_SCRIBES_EXTRA="
{
  \"scFormat\": \"ScText\",
  \"scKind\": \"FileSK\",
  \"scName\": \"${CARDANO_BASE_DIR}/log/${NAME}.log\",
  \"scRotation\": null
}
"

HAS_PROMETHEUS="[\"0.0.0.0\",${PROMETHEUS_PORT}]"

MAP_BACKENDS='
{
 "cardano.node.metrics": [
     "TraceForwarderBK"
 ],
 "cardano.node-metrics": [
    "TraceForwarderBK"
 ],
 "cardano.node.Forge.metrics": [
    "TraceForwarderBK"
 ],
 "cardano.node.BlockFetchDecision.peers": [
    "TraceForwarderBK"
 ],
 "cardano.node.ChainDB.metrics": [
    "TraceForwarderBK"
 ],
 "cardano.node.resources": [
    "TraceForwarderBK"
 ]	  
}
'

i=mainnet-config.json

TESTNET="testnet"

if [ $NETWORK = $TESTNET ];then 
    i=testnet-config.json 
fi

jq '.TraceBlockFetchDecisions = true'      $CONFIG_ETC/$i   > $CONFIG_DST/$i

cp $CONFIG_DST/$i /tmp/$i

jq ".defaultScribes = $DEFAULT_SCRIBES"    /tmp/$i > $CONFIG_DST/$i

cp $CONFIG_DST/$i /tmp/$i

jq ".hasPrometheus = $HAS_PROMETHEUS"      /tmp/$i > $CONFIG_DST/$i

cp $CONFIG_DST/$i /tmp/$i

jq ".TraceForwardTo = $TRACE_FORWARD_TO"   /tmp/$i > $CONFIG_DST/$i

cp $CONFIG_DST/$i /tmp/$i

jq ".options.mapBackends = $MAP_BACKENDS"  /tmp/$i > $CONFIG_DST/$i

cp $CONFIG_DST/$i /tmp/$i

jq ".setupScribes[1] |= . + $SETUP_SCRIBES_EXTRA" /tmp/$i > $CONFIG_DST/$i
    
rm -rf /tmp/$i
    
echo "hacking config file: $CONFIG_DST/$i"


