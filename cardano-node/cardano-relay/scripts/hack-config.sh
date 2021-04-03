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

HAS_PROMETHEUS="[\"0.0.0.0\",12798]"

MAP_BACKENDS='
{
 "cardano.node.metrics": [
   "TraceForwarderBK"
 ],
 "cardano.node.resources": [
   "TraceForwarderBK"
 ],
 "cardano.node.AcceptPolicy": [
  "TraceForwarderBK"
 ],
 "cardano.node.ChainDB": [
  "TraceForwarderBK"
 ],
 "cardano.node.DnsResolver": [
  "TraceForwarderBK"
 ],
 "cardano.node.DnsSubscription": [
  "TraceForwarderBK"
 ],
 "cardano.node.ErrorPolicy": [
  "TraceForwarderBK"
 ],
 "cardano.node.Handshake": [
  "TraceForwarderBK"
 ],
 "cardano.node.IpSubscription": [
  "TraceForwarderBK"
 ],
 "cardano.node.LocalErrorPolicy": [
  "TraceForwarderBK"
 ],
 "cardano.node.LocalHandshake": [
  "TraceForwarderBK"
 ],
 "cardano.node.Mux": [
  "TraceForwarderBK"
 ]
}
'
MAP_SUBTRACE='
{
    "#ekgview": {
	"contents": [
	    [
		{
		    "contents": "cardano.epoch-validation.benchmark",
		    "tag": "Contains"
		},
		[
		    {
			"contents": ".monoclock.basic.",
			"tag": "Contains"
		    }
		]
	    ],
	    [
		{
		    "contents": "cardano.epoch-validation.benchmark",
		    "tag": "Contains"
		},
		[
		    {
			"contents": "diff.RTS.cpuNs.timed.",
			"tag": "Contains"
		    }
		]
	    ],
	    [
		{
		    "contents": "#ekgview.#aggregation.cardano.epoch-validation.benchmark",
		    "tag": "StartsWith"
		},
		[
		    {
			"contents": "diff.RTS.gcNum.timed.",
			"tag": "Contains"
		    }
		]
	    ]
	],
	"subtrace": "FilterTrace"
    },
    "benchmark": {
	"contents": [
	    "GhcRtsStats",
	    "MonotonicClock"
	],
	"subtrace": "ObservableTrace"
    },
    "cardano.epoch-validation.utxo-stats": {
	"subtrace": "NoTrace"
    },
    "cardano.node-metrics": {
	"subtrace": "Neutral"
    },
    "cardano.node.metrics": {
	"subtrace": "Neutral"
    }
}'

SETUP_BACKENDS0='"TraceForwarderBK"'
SETUP_BACKENDS1='"EKGViewBK"'


i=mainnet-config.json

TESTNET="testnet"

if [ $NETWORK = $TESTNET ];then 
    i=testnet-config.json 
fi

jq '.TraceBlockFetchDecisions = true'      $CONFIG_ETC/$i   > $CONFIG_DST/$i


cp $CONFIG_DST/$i /tmp/$i

# jq ".defaultScribes = $DEFAULT_SCRIBES"    /tmp/$i > $CONFIG_DST/$i

# cp $CONFIG_DST/$i /tmp/$i

jq ".hasPrometheus = $HAS_PROMETHEUS"      /tmp/$i > $CONFIG_DST/$i

cp $CONFIG_DST/$i /tmp/$i

jq ".traceForwardTo = $TRACE_FORWARD_TO"   /tmp/$i > $CONFIG_DST/$i

cp $CONFIG_DST/$i /tmp/$i

jq ".options.mapBackends = $MAP_BACKENDS"  /tmp/$i > $CONFIG_DST/$i

cp $CONFIG_DST/$i /tmp/$i

jq ".options.mapSubtrace = $MAP_SUBTRACE"  /tmp/$i > $CONFIG_DST/$i

cp $CONFIG_DST/$i /tmp/$i

# jq ".setupScribes[1] |= . + $SETUP_SCRIBES_EXTRA" /tmp/$i > $CONFIG_DST/$i

# cp $CONFIG_DST/$i /tmp/$i

jq ".setupBackends[0] =   $SETUP_BACKENDS0" /tmp/$i > $CONFIG_DST/$i

cp $CONFIG_DST/$i /tmp/$i

jq ".setupBackends[] =   $SETUP_BACKENDS1" /tmp/$i > $CONFIG_DST/$i

if [[ $TYPE == $PRODUCER_TYPE ]];then
    echo "trace mempool is true" 
else
    echo "trace mempool is false"
    cp $CONFIG_DST/$i /tmp/$i
    jq ".TraceMempool = false"   /tmp/$i > $CONFIG_DST/$i
fi

rm -rf /tmp/$i
    
echo "hacking config file: $CONFIG_DST/$i"


