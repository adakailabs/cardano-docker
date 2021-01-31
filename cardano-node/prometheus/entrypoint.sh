#!/bin/bash

echo "starting prometheus..." 

set -e

if [ $1 == "" ]; then
    echo "WARN: relay instances  not specified, using default"
    RELAY_INSTANCES="1"
fi

RELAY_INSTANCES=$1

if [ $1 == "" ]; then
    echo "WARN: producer instances  not specified, using default"
    PRODUCER_INSTANCES="1"
fi

PRODUCER_INSTANCES=$2

CONFIG_DIR="/prometheus/"
CONFIG_FILE_ETC=/etc/prometheus/prometheus.yml
CONFIG_FILE_LOCAL="$CONFIG_DIR/prometheus.yml"
CONFIG_FILE_TMP=/tmp/prometheus.yml

echo "CONFIG: $CONFIG_DIR"

mkdir -p $CONFIG_DIR \
      && cp $CONFIG_FILE_ETC $CONFIG_FILE_TMP

cp $CONFIG_FILE_ETC $CONFIG_FILE_LOCAL

CONFIG_TPL="

  - job_name: '{{name-node}}'
    scrape_interval: 5s
    static_configs:
      - targets: ['{{host}}:{{node}}']

  - job_name: '{{name-cardano}}' 
    scrape_interval: 5s
    static_configs:
      - targets: ['{{host}}:{{prometheus}}']
"


CONFIG=""
echo "----------------------------------------"

for (( i=0; i<$RELAY_INSTANCES; i++ ))
do
    
    PROMETHEUS_PORT=$(printf '127%02d' "${i}")
    PROMETHEUS_NODE_EXPORT_PORT=$(printf '91%02d' "${i}")
    HOST_NAME="relay${i}"
    NAME_NODE="${HOST_NAME}-exporter"
    NAME_CARDANO="${HOST_NAME}-cardano"

    C=$(echo "$CONFIG_TPL" | sed "s/{{prometheus}}/${PROMETHEUS_PORT}/")
    C=$(echo "$C" | sed "s/{{node}}/${PROMETHEUS_NODE_EXPORT_PORT}/")
    C=$(echo "$C" | sed "s/{{host}}/${HOST_NAME}/")
    C=$(echo "$C" | sed "s/{{name-node}}/${NAME_NODE}/")
    C=$(echo "$C" | sed "s/{{name-cardano}}/${NAME_CARDANO}/")

    
    CONFIG="$CONFIG $C"
done

for (( i=0; i<$PRODUCER_INSTANCES; i++ ))
do
    j=$(($RELAY_INSTANCES+$i))

    PROMETHEUS_PORT=$(printf '127%02d' "${j}")
    PROMETHEUS_NODE_EXPORT_PORT=$(printf '91%02d' "${j}")
    HOST_NAME="producer${i}"
    NAME_NODE="${HOST_NAME}-exporter"
    NAME_CARDANO="${HOST_NAME}-cardano"

    C=$(echo "$CONFIG_TPL" | sed "s/{{prometheus}}/${PROMETHEUS_PORT}/")
    C=$(echo "$C" | sed "s/{{node}}/${PROMETHEUS_NODE_EXPORT_PORT}/")
    C=$(echo "$C" | sed "s/{{host}}/${HOST_NAME}/")
    C=$(echo "$C" | sed "s/{{name-node}}/${NAME_NODE}/")
    C=$(echo "$C" | sed "s/{{name-cardano}}/${NAME_CARDANO}/")

    
    CONFIG="$CONFIG $C"

done

echo "$CONFIG" >> $CONFIG_FILE_LOCAL 

echo "

RELAY INSTANCES    : $RELAY_INSTANCES
PRODUCER INSTANCES : $PRODUCER_INSTANCES 
CONFIG PATH        : $CONFIG_FILE_LOCAL
----------------------------------------
"



exec prometheus --config.file=$CONFIG_FILE_LOCAL --storage.tsdb.path=/prometheus --web.console.libraries=/usr/share/prometheus/console_libraries --web.console.templates=/usr/share/prometheus/consoles
