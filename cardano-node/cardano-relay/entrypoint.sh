#!/bin/bash
#set -x
set -e

MAINNET_MAGIC=764824073
TESTNET_MAGIC=1097911063

# Load argsparse library.
. argsparse.sh

argsparse_use_option testnet "run in testnet mode"

argsparse_use_option standalone "run in standalone mode"

argsparse_use_option secrets_path "secrets dir"  value

argsparse_use_option id "node id (0, 1, 2, ...)"  value

argsparse_use_option type "node type (producer or relay)"  value

argsparse_use_option mock "run in mock mode"

argsparse_use_option test "run in test mode" 

printf -v argsparse_usage_description "%s\n" \
	"entry point for starting a cardano node" \
	"Try command lines such as:" \
	" $0" \
	" $0 -h" \
	" $0 --id nodeID "\
	" $0 --type nodeType "\
	" $0 --mock " \
	" $0 --test "\	
	
# Command line parsing is done here.
argsparse_parse_options "$@"

printf "Options reporting:\n"
# Simple reporting function.
argsparse_report
printf "End of argsparse report.\n\n"

if argsparse_is_option_set "standalone"
then
    echo "standalone is set" 
    STANDALONE=${program_options[type]}
    TYPE="relay"
    ID=0
fi

if argsparse_is_option_set "id"
then
    echo "id is ${program_options[id]}"
    ID=${program_options[id]}
else
    if argsparse_is_option_set "standalone"
    then
	echo "standalone is set"
    else
	echo "id option must be specified"q
	echo "type option must be specified"
	exit 0
    fi    
fi



if argsparse_is_option_set "type"
then
    echo "type is ${program_options[type]}"
    TYPE=${program_options[type]}
else
    if argsparse_is_option_set "standalone"
    then
	echo "standalone is set"
    else
    echo "type option must be specified"
    exit 0
    fi
fi

if argsparse_is_option_set "secrets_path"
then
    echo "path to secrets ${program_options[secrets_path]}"

else
    if argsparse_is_option_set "standalone"
    then
	echo "standalone is set"
    else
	echo "type secrets_path must be specified"
	exit 0
    fi
fi

if argsparse_is_option_set "testnet"
then
    echo "running in testnet mode"
    NET="testnet"
else
    echo "running in mainnet mode"
    NET="mainnet"
fi




secrets_path=${program_options[secrets_path]}

PRODUCER_TYPE="producer"

if [[ $TYPE == $PRODUCER_TYPE ]];then
    NAME=${program_options[type]}
else
    NAME="${TYPE}${ID}"
fi    



ERA1=shelley
ERA2=byron

ERA1_JSON=${NET}-${ERA1}-genesis.json
ERA2_JSON=${NET}-${ERA2}-genesis.json

BASE_PATH="/home/lovelace/cardano-node/${NAME}"

mkdir -p $BASE_PATH/config

CONFIG_DIR=$BASE_PATH/config
GENESIS1=$CONFIG_DIR/$ERA1_JSON
GENESIS2=$CONFIG_DIR/$ERA2_JSON



TOPOLOGY=$BASE_PATH/config/${NAME}-topology.json
TOPOLOGY_ETC=/etc/cardano/configuration/cardano/mainnet-topology.json

if argsparse_is_option_set "testnet"
then
    TOPOLOGY_ETC=/etc/cardano/configuration/cardano/testnet-topology.json
fi


CONFIG=$BASE_PATH/config/${TYPE}-config.json

PROMETHEUS_PORT="12798"
CARDANO_PORT="3001"
PROMETHEUS_NODE_EXPORT_PORT="9100"



if [[ $TYPE == $PRODUCER_TYPE ]];then
    RT_VIEW_PORT="6602"
else
    RT_VIEW_PORT=$(printf '66%02d' "${ID}")
fi    

if [ $ID==0 ]
then
    if argsparse_is_option_set "standalone"
    then    
	PRODUCER0_ADDR="0.0.0.0"
	RELAY_THIS_PUBLIC_ADDR="0.0.0.0"
	RELAY_OTHER_PUBLIC_ADDR="0.0.0.0"
	RELAY_THIS_PRIVATE_ADDR="0.0.0.0"
	RELAY_OTHER_PRIVATE_ADDR="0.0.0.0"
    else
	PRODUCER0_ADDR=`cat $secrets_path/producer_private_host_name`
	RELAY_THIS_PUBLIC_ADDR=`cat $secrets_path/relay0_public_host_name`
	RELAY_OTHER_PUBLIC_ADDR=`cat $secrets_path/relay1_public_host_name`
	RELAY_THIS_PRIVATE_ADDR=`cat $secrets_path/relay0_private_host_name`
	RELAY_OTHER_PRIVATE_ADDR=` cat $secrets_path/relay1_private_host_name`
    fi
else
    PRODUCER0_ADDR=`cat $secrets_path/producer_private_host_name`
    RELAY_THIS_PUBLIC_ADDR=`cat $secrets_path/relay1_public_host_name`
    RELAY_OTHER_PUBLIC_ADDR=`cat $secrets_path/relay0_public_host_name`
    RELAY_THIS_PRIVATE_ADDR=`cat $secrets_path/relay1_private_host_name`
    RELAY_OTHER_PRIVATE_ADDR=` cat $secrets_path/relay0_private_host_name`
fi



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

# Start prometheus monitoring in the background
echo "Starting node_exporter..."

if argsparse_is_option_set "mock"
then
    echo "*****************************************************"
    echo "              running in mocking mode"
    echo "*****************************************************"
else
nohup node_exporter --web.listen-address=":${PROETHEUS_NODE_EXPORT_PORT}" &
fi

echo "$CONFIG found, copying from /etc/cardano-node"
cp /etc/cardano/configuration/cardano/mainnet-config.json $CONFIG

if argsparse_is_option_set "testnet"
then
    cp /etc/cardano/configuration/cardano/testnet-config.json $CONFIG
fi

sed -i "s/{{node-name}}/${NAME}/g" $CONFIG
sed -i "s/{{node-id}}/${RT_VIEW_PORT}/g" $CONFIG
sed -i "s/{{prometheus-port}}/${PROMETHEUS_PORT}/g" $CONFIG

if argsparse_is_option_set "testnet"
then
    sed -i "s/\"ApplicationVersion\": 1/\"ApplicationVersion\": 0/g" $CONFIG
    sed -i "s/mainnet/testnet/g" $CONFIG
    sed -i "s/\"ByronGenesisHash\":.*\"/\"ByronGenesisHash\": \"96fceff972c2c06bd3bb5243c39215333be6d56aaf4823073dca31afe5038471\"/g" $CONFIG
    sed -i "s/\"ShelleyGenesisHash\":.*\"/\"ShelleyGenesisHash\": \"39bf1f46577653eb3062eaf03e5dd31144661ea20b673d2fe5d91654697fb23d\"/g" $CONFIG
    sed -i "s/RequiresNoMagic/RequiresMagic/g" $CONFIG
    
fi


cp $TOPOLOGY_ETC $TOPOLOGY
sed -i "s/{{relay-this-public-addr}}/${RELAY_THIS_PUBLIC_ADDR}/g" $TOPOLOGY
sed -i "s/{{relay-other-public-addr}}/${RELAY_OTHER_PUBLIC_ADDR}/g" $TOPOLOGY
sed -i "s/{{relay-this-private-addr}}/${RELAY_THIS_PRIVATE_ADDR}/g" $TOPOLOGY
sed -i "s/{{relay-other-private-addr}}/${RELAY_OTHER_PRIVATE_ADDR}/g" $TOPOLOGY
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


#echo "export CARDANO_NODE_SOCKET_PATH=/home/lovelace/cardano-node/${NAME}/db/node.socket" >> /etc/profile.d/00-env.sh


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
#ls -rtl $secrets_path

else
cmd_args="$database_path $socket_path $port $host_address $config $topology"    
fi     

if argsparse_is_option_set "test"
then
    cmd_args="$database_path $socket_path $port $host_address $config $topology"
    echo "**********************************************************************"
    echo $cmd_args
    echo "**********************************************************************"
fi

if argsparse_is_option_set "mock"
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






