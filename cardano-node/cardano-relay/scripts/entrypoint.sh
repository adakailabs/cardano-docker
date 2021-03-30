#!/bin/bash
#set -x
set -e

export PATH="$PATH:$PWD"
export SECRETS_PATH=/etc/cardano/testsecrets/
export NETWORK=mainnet
export ID=0
export TYPE
export TEST_MODE=false
export MOCK_MODE=false
export PRODUCER0_ADDR
export PRODUCER_PUBLIC_ADDR
export RELAY_THIS_PUBLIC_ADDR
export RELAY_OTHER_PUBLIC_ADDR
export RELAY_THIS_PRIVATE_ADDR
export RELAY_OTHER_PRIVATE_ADDR
export ERA1=shelley
export ERA2=byron
export PROMETHEUS_PORT="12798"
export CARDANO_PORT="3001"
export PROMETHEUS_NODE_EXPORT_PORT="9100"
export PRODUCER_TYPE="producer"
export RT_VIEW_PORT="6600"
export NAME
export STANDALONE=false

# Load argsparse library.
. argsparse.sh

argsparse_use_option secrets_path "secrets dir"  value

argsparse_use_option id "node id (0, 1, 2, ...)"  value

argsparse_use_option type "node type (producer or relay)"  value

argsparse_use_option mock "run in mock mode"

argsparse_use_option test "run in test mode" 

argsparse_use_option testnet "use testnet" 

argsparse_use_option standalone "standalone mode" 
	
# Command line parsing is done here.
argsparse_parse_options "$@"

printf "Options reporting:\n"
# Simple reporting function.
argsparse_report
printf "End of argsparse report.\n\n"


if argsparse_is_option_set "standalone"
then
    STANDALONE=true
    ID=0
    TYPE=relay
else
    STANDALONE=false
fi

if argsparse_is_option_set "mock"
then
    MOCK_MODE=true
else
    MODE_MODE=false
fi

if argsparse_is_option_set "test"
then
    TEST_MODE=true
else
    TEST_MODE=false
fi


if argsparse_is_option_set "id"
then
    echo "id is ${program_options[id]}"
    ID=${program_options[id]}
else
    if [ $STANDALONE = false ]; then
    echo "id option must be specified"
    exit 0
    fi
fi

if argsparse_is_option_set "type"
then
    echo "type is ${program_options[type]}"
    TYPE=${program_options[type]}
else
    if [ $STANDALONE = false ]; then
    echo "type option must be specified"
    exit 0
    fi
fi

if argsparse_is_option_set "secrets_path"
then
    SECRETS_PATH=${program_options[secrets_path]}
    echo "path to secrets $SECRETS_PATH"
else
    if [ $STANDALONE = false ]; then
	echo "path to secrets must be specified"
	exit 0
    fi
fi

if argsparse_is_option_set "testnet"
then
    NETWORK=testnet
    echo "network is $NETWORK"
fi

printf -v argsparse_usage_description "%s\n" \
	"entry point for starting a cardano node" \
	"Try command lines such as:" \
	" $0" \
	" $0 -h" \
	" $0 --id nodeID "\
	" $0 --type nodeType "\
	" $0 --mock " \
	" $0 --test "\	



if [[ $TYPE == $PRODUCER_TYPE ]];then
    NAME=$TYPE
    RT_VIEW_PORT=6602
    #PROMETHEUS_PORT=12798

else
    NAME="${TYPE}${ID}"
    RT_VIEW_PORT=$(printf '66%02d' ${ID})
    #PROMETHEUS_PORT=$(printf '12798' ${ID})
fi    



export ERA1_JSON=${NETWORK}-${ERA1}-genesis.json
export ERA2_JSON=${NETWORK}-${ERA2}-genesis.json

export CARDANO_BASE_DIR=/home/lovelace/cardano-node/${NETWORK}/${NAME}
export CARDANO_CONFIG_DIR=$CARDANO_BASE_DIR/config
export CONFIG_ETC=/etc/cardano/config
export CONFIG_DST=$CARDANO_CONFIG_DIR
export CONFIG_NAME=${NETWORK}-config.json
export CONFIG_NEW=${NETWORK}-config-new.json

mkdir -p $CARDANO_CONFIG_DIR


TOPOLOGY=$CARDANO_CONFIG_DIR/${NETWORK}-topology.json
TOPOLOGY_ETC=/etc/cardano/config/${NETWORK}-topology.json

CONFIG=$CARDANO_CONFIG_DIR/${NETWORK}-config.json


source hack-secrets.sh 

echo "
-----------------------------------------------
Node Name           : $NAME
Node Exporter Port  : $PROMETHEUS_NODE_EXPORT_PORT
Prometheus Port     : $PROMETHEUS_PORT
RT View Port        : $RT_VIEW_PORT
Cardano Port        : $CARDANO_PORT
Producer Addr       : $PRODUCER0_ADDR
Relay This Public   : $RELAY_THIS_PUBLIC_ADDR
Relay Other Public  : $RELAY_OTHER_PUBLIC_ADDR
Relay This Private  : $RELAY_THIS_PRIVATE_ADDR
Relay Other Private : $RELAY_OTHER_PRIVATE_ADDR
-----------------------------------------------
"

hack-config.sh

hack-topology.sh 

hack-genesis.sh

# Start prometheus monitoring in the background
echo "Starting node_exporter..."
if [ $MOCK_MODE = true ]
then
    echo "*****************************************************"
    echo "              running in mocking mode"
    echo "*****************************************************"
else
nohup node_exporter --web.listen-address=":${PROETHEUS_NODE_EXPORT_PORT}" &
fi


database_path="--database-path $CARDANO_BASE_DIR/db/"
socket_path="--socket-path $CARDANO_BASE_DIR/db/node.socket"
port="--port $CARDANO_PORT "
host_address="--host-addr 0.0.0.0"
config="--config $CONFIG"
topology="--topology $TOPOLOGY"
shelley_kes_key="--shelley-kes-key $SHELLEY_KES_KEY_FILE"
shelley_vrf_key="--shelley-vrf-key $SHELLEY_VRF_KEY_FILE"
shelley_operational_certificate="--shelley-operational-certificate $SHELLEY_OPERATIONAL_CERTIFICATE_FILE"


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
    
    #sleep 1m
    cmd_args="$database_path $socket_path $port $host_address $config $topology $shelley_kes_key $shelley_vrf_key $shelley_operational_certificate"
    #ls -rtl $secrets_path
    
else
    cmd_args="$database_path $socket_path $port $host_address $config $topology"    
fi     

if [ $TEST_MODE = true ]
then
    cmd_args="$database_path $socket_path $port $host_address $config $topology"
    echo "**********************************************************************"
    echo $cmd_args
    echo "**********************************************************************"
fi

if [ $MOCK_MODE = true ] 
then
    echo "**********************************************************************"
    echo $cmd_args
    echo "**********************************************************************"
else
    echo "**********************************************************************"
    echo $cmd_args
    echo "**********************************************************************"
    cardano-node run $cmd_args 
fi






