#!/bin/bash

set -e


PRODUCER_PUBLIC_ADDR=`cat $SECRETS_PATH/producer_public_host_name`

if [ $ID==0 ]
then
    PRODUCER0_ADDR=`cat $SECRETS_PATH/producer_private_host_name`
    PRODUCER_PUBLIC_ADDR=`cat $SECRETS_PATH/producer_public_host_name`
    RELAY_THIS_PUBLIC_ADDR=`cat $SECRETS_PATH/relay0_public_host_name`
    RELAY_OTHER_PUBLIC_ADDR=`cat $SECRETS_PATH/relay1_public_host_name`
    RELAY_THIS_PRIVATE_ADDR=`cat $SECRETS_PATH/relay0_private_host_name`
    RELAY_OTHER_PRIVATE_ADDR=` cat $SECRETS_PATH/relay1_private_host_name`
    
else
    PRODUCER0_ADDR=`cat $SECRETS_PATH/producer_private_host_name`
    PRODUCER_PUBLIC_ADDR=`cat $SECRETS_PATH/producer_public_host_name`
    RELAY_THIS_PUBLIC_ADDR=`cat $SECRETS_PATH/relay1_public_host_name`
    RELAY_OTHER_PUBLIC_ADDR=`cat $SECRETS_PATH/relay0_public_host_name`
    RELAY_THIS_PRIVATE_ADDR=`cat $SECRETS_PATH/relay1_private_host_name`
    RELAY_OTHER_PRIVATE_ADDR=` cat $SECRETS_PATH/relay0_private_host_name`
fi

# node.cert  node_kes.key  node_kes.vkey  node_vrf.key  node_vrf.vkey
SHELLEY_KES_KEY_FILE="$SECRETS_PATH/node_kes.key"
SHELLEY_VRF_KEY_FILE="$SECRETS_PATH/node_vrf.key"
SHELLEY_OPERATIONAL_CERTIFICATE_FILE="$SECRETS_PATH/node.cert"



