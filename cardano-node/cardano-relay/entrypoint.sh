#!/bin/bash
#set -x
set -e

# Load argsparse library.
. argsparse.sh

# Declaring an option not accepting a value and not having a
# single-char equivalent.
argsparse_use_option name "node name (relay_this, relay_other, producer0)" value

# Declaring an option not accepting a value but with a single-char
# equivalent.

# "short" is a property, and "o" is the value of the "short" property
# for this option. Argsparse can handle other properties, see other
# tutorials.
argsparse_use_option id "node id (0, 1, 2, ...)"  value

argsparse_use_option type "node type (producer or relay)"  value

argsparse_use_option relay_this_addr "relay 0 IP address or name"  value
argsparse_use_option relay_other_addr "relay 1 IP address or name"  value
argsparse_use_option producer_addr "relay 0 IP address or name"  value


argsparse_use_option test "run in test mode" 

printf -v argsparse_usage_description "%s\n" \
	"entry point for starting a cardano node" \
	"Try command lines such as:" \
	" $0" \
	" $0 -h" \
	" $0 --name nodeName" \
	" $0 --id nodeID "\
	" $0 --type nodeType "\
	" $0 --test "\	
	
# Command line parsing is done here.
argsparse_parse_options "$@"

printf "Options reporting:\n"
# Simple reporting function.
argsparse_report
printf "End of argsparse report.\n\n"


if argsparse_is_option_set "id"
then
    echo "id is ${program_options[id]}"
else
    echo "id option must be specified"
    exit 0
fi

if argsparse_is_option_set "type"
then
    echo "type is ${program_options[type]}"
    TYPE=${program_options[type]}
else
    echo "type option must be specified"
    exit 0
fi

if argsparse_is_option_set "producer_addr"
then
    echo "producer addr is ${program_options[producer_addr]}"
else
    echo "producer addr must must be specified"
    exit 0
fi

if argsparse_is_option_set "relay_this_addr"
then
    echo "relay_this address is ${program_options[relay_this_addr]}"
else
    echo "relay_this addr must must be specified"
    exit 0
fi

if argsparse_is_option_set "relay_other_addr"
then
    echo "relay_other address is ${program_options[relay_other_addr]}"
else
    echo "relay_other addr must must be specified"
    exit 0
fi

PRODUCER_TYPE="producer"

if [[ $TYPE == $PRODUCER_TYPE ]];then
    NAME=${program_options[type]}
else
    NAME="${program_options[type]}${program_options[id]}"
fi    

ID=${program_options[id]}

ERA1=shelley
ERA2=byron

ERA1_JSON=mainnet-${ERA1}-genesis.json
ERA2_JSON=mainnet-${ERA2}-genesis.json

BASE_PATH="/home/lovelace/cardano-node/${NAME}"

mkdir -p $BASE_PATH/secrets 
mkdir -p $BASE_PATH/config

CONFIG_DIR=$BASE_PATH/config
GENESIS1=$CONFIG_DIR/$ERA1_JSON
GENESIS2=$CONFIG_DIR/$ERA2_JSON

TOPOLOGY=$BASE_PATH/config/${NAME}-topology.json
TOPOLOGY_ETC=/etc/cardano/config/${NAME}-topology.json

CONFIG=$BASE_PATH/config/${TYPE}-config.json

PROMETHEUS_PORT="12798"
CARDANO_PORT="3001"
PROMETHEUS_NODE_EXPORT_PORT="9100"

RT_VIEW_PORT=$(printf '66%02d' "${ID}")

PRODUCER0_ADDR=${program_options["producer_addr"]}
RELAY_THIS_ADDR=${program_options["relay_this_addr"]}
RELAY_OTHER_ADDR=${program_options["relay_other_addr"]}


echo "
-----------------------------------------------
Node Name    : $NAME
Prom Port    : $PROMETHEUS_NODE_EXPORT_PORT
Prometh Port : $PROMETHEUS_PORT
RT View Port : $RT_VIEW_PORT
Cardano Port : $CARDANO_PORT
Producer Addr: $PRODUCER0_ADDR
Relay This   : $RELAY_THIS_ADDR
Relay Other  : $RELAY_OTHER_ADDR
-----------------------------------------------
"

# Start prometheus monitoring in the background
echo "Starting node_exporter..."

if argsparse_is_option_set "test"
then
    echo "*****************************************************"
    echo "              running in testing mode"
    echo "*****************************************************"
else
nohup node_exporter --web.listen-address=":${PROETHEUS_NODE_EXPORT_PORT}" &
fi

if [ -f "$CONFIG" ]; then
    echo "$CONFIG found, copying from /etc/cardano-node"
    cp /etc/cardano/config/${TYPE}-config.json $CONFIG
    sed -i "s/{{node-name}}/${NAME}/g" $CONFIG
    sed -i "s/{{node-id}}/${RT_VIEW_PORT}/g" $CONFIG
    sed -i "s/{{prometheus-port}}/${PROMETHEUS_PORT}/g" $CONFIG
else 
    echo echo "$CONFIG NOT found, copying from /etc/cardano-node"
    cp /etc/cardano/config/${TYPE}-config.json $CONFIG
    sed -i "s/{{node-name}}/${NAME}/g" $CONFIG
    sed -i "s/{{node-id}}/${RT_VIEW_PORT}/g" $CONFIG
    sed -i "s/{{prometheus-port}}/${PROMETHEUS_PORT}/g" $CONFIG
    
fi

cp $TOPOLOGY_ETC $TOPOLOGY
sed -i "s/{{relay-this-addr}}/${RELAY_THIS_ADDR}/g" $TOPOLOGY
sed -i "s/{{relay-other-addr}}/${RELAY_OTHER_ADDR}/g" $TOPOLOGY
sed -i "s/{{producer-addr}}/${PRODUCER0_ADDR}/g" $TOPOLOGY


if [ -f "$GENESIS1" ]; then
    echo "$GENESIS1 found."
    cp /etc/cardano/config/$ERA1_JSON $GENESIS1
else 
    echo echo "$GENESIS1 NOT found, copying from /etc/cardano-node"
    cp /etc/cardano/config/$ERA1_JSON $GENESIS1
fi

if [ -f "$GENESIS2" ]; then
    echo "$GENESIS2 found."
    cp /etc/cardano/config/$ERA2_JSON $GENESIS2
else 
    echo echo "$GENESIS2 NOT found, copying from /etc/cardano-node"
    cp /etc/cardano/config/$ERA2_JSON $GENESIS2
fi


secrets_path="/run/secrets"
shelley_kes_key_file="$secrets_path/kes_key.skey"
shelley_vrf_key_file="$secrets_path/vrf_skey.skey"
shelley_operational_certificate_file="$secrets_path/operational_certificate.cert"


database_path="--database-path $BASE_PATH/db/"
socket_path="--socket-path $BASE_PATH/db/node.socket"
port="--port $CARDANO_PORT "
host_address="--host-addr 0.0.0.0"
config="--config $CONFIG"
topology="--topology $TOPOLOGY"
shelley_kes_key="--shelley-kes-key $shelley_kes_key_file"
shelley_vrf_key="--shelley-vrf-key $shelley_vrf_key_file"
shelley_operational_certificate="--shelley-operational-certificate $shelley_operational_certificate_file"




echo "--------------------------------------------------------------------------"
echo "database_path                   : $database_path"
echo "socket_path                     : $socket_path"
echo "port                            : $port          "
echo "host_address                    : $host_address"
echo "config                          : $config"
echo "topology                        : $topology"


if [[ $TYPE == $PRODUCER_TYPE ]];then
  
echo "shelley_kes_key                 : $shelley_kes_key"
echo "shelley-vrf-key                 : $shelley_vrf_key"
echo "shelley_operational_certificate : $shelley_operational_certificate"
echo "--------------------------------------------------------------------------"


cmd_args="$database_path $socket_path $port $host_address $config $topology $shelley_kes_key $shelley_vrf_key $shelley_operational_certificate"
ls -rtl $secrets_path

else
cmd_args="$database_path $socket_path $port $host_address $config $topology"    
fi     


if argsparse_is_option_set "test"
then
    cmd_args="$database_path $socket_path $port $host_address $config $topology"
    echo "**********************************************************************"
    echo $cmd_args
    echo "**********************************************************************"
else
    echo "**********************************************************************"
    echo $cmd_args
    echo "**********************************************************************"
    cardano-node run $cmd_args 
fi






