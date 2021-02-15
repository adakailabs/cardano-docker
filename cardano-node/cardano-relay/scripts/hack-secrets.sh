#!/bin/bash

set -e


if [ $ID==0 ]
then
    PRODUCER0_ADDR=`cat $SECRETS_PATH/producer_private_host_name`
    RELAY_THIS_PUBLIC_ADDR=`cat $SECRETS_PATH/relay0_public_host_name`
    RELAY_OTHER_PUBLIC_ADDR=`cat $SECRETS_PATH/relay1_public_host_name`
    RELAY_THIS_PRIVATE_ADDR=`cat $SECRETS_PATH/relay0_private_host_name`
    RELAY_OTHER_PRIVATE_ADDR=` cat $SECRETS_PATH/relay1_private_host_name`
    
else
    PRODUCER0_ADDR=`cat $SECRETS_PATH/producer_private_host_name`
    RELAY_THIS_PUBLIC_ADDR=`cat $SECRETS_PATH/relay1_public_host_name`
    RELAY_OTHER_PUBLIC_ADDR=`cat $SECRETS_PATH/relay0_public_host_name`
    RELAY_THIS_PRIVATE_ADDR=`cat $SECRETS_PATH/relay1_private_host_name`
    RELAY_OTHER_PRIVATE_ADDR=` cat $SECRETS_PATH/relay0_private_host_name`
fi


SHELLEY_KES_KEY_FILE="$SECRETS_PATH/kes_key.skey"
SHELLEY_VRF_KEY_FILE="$SECRETS_PATH/vrf_skey.skey"
SHELLEY_OPERATIONAL_CERTIFICATE_FILE="$SECRETS_PATH/operational_certificate.cert"



