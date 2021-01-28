#!/bin/bash
set -e

# cardano-rt-view - real-time view for cardano node.

# Usage: cardano-rt-view [--config FILEPATH] [--notifications FILEPATH] 
#                       [--static FILEPATH] [--port PORT] 
#                       [--active-node-life TIME] [-v|--version] 
#                       [--supported-nodes]

#Available options:
#   --config FILEPATH        Configuration file for RTView service. If not
#                           provided, interactive dialog will be started.
#  --notifications FILEPATH Configuration file for notifications
#  --static FILEPATH        Directory with static content (default: "static")
#  --port PORT              The port number (default: 8024)
#  --active-node-life TIME  Active node lifetime, in seconds (default: 120)
#  -h,--help                Show this help text
#  -v,--version             Show version
#  --supported-nodes        Show supported versions of Cardano node

CONFIG_FILE_ETC=/etc/cardano/rt-view/cardano-rt-view.json
CONFIG_FILE_LOCAL=/home/lovelace/cardano-node/rt-view/cardano-rt-view.json
CONFIG_FILE_TMP=/tmp/cardano-rt-view.json

mkdir -p /home/lovelace/cardano-node/rt-view/ \
      && cp $CONFIG_FILE_ETC $CONFIG_FILE_TMP


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

CONFIG="["
echo "----------------------------------------"

for (( i=0; i<=$RELAY_INSTANCES; i++ ))
do

    RT_VIEW_PORT=$(printf '66%02d' "${i}")
    C="{\"remoteAddr\": {\"tag\": \"RemoteSocket\",\"contents\": [\"0.0.0.0\",\"${RT_VIEW_PORT}\"]},\"nodeName\": \"relay$i\"}"

    if [[ $i -eq 0 ]]
    then
	CONFIG="$CONFIG $C"
    else

	if [[ $i -eq $RELAY_INSTANCES ]]
	then

	    if [[ 0 -eq $PRODUCER_INSTANCES ]]
            then
		CONFIG="$CONFIG ]"
		echo "RELAY NAME         : relay$i"
	    else
		CONFIG="$CONFIG ,"
		echo "RELAY NAME         : relay$i"
	    fi
	else
	    CONFIG=$CONFIG,$C
	    echo "RELAY NAME         : relay$i"
	fi
    fi
    
done

for (( i=0; i<=$PRODUCER_INSTANCES; i++ ))
do
    j=$(($RELAY_INSTANCES+$i))
    RT_VIEW_PORT=$(printf '66%02d' "${j}")
    C="{\"remoteAddr\": {\"tag\": \"RemoteSocket\",\"contents\": [\"0.0.0.0\",\"${RT_VIEW_PORT}\"]},\"nodeName\": \"producer$i\"}"

    if [[ $i -eq 0 ]]
    then
	CONFIG="$CONFIG $C"
    else

	if [[ $i -eq $PRODUCER_INSTANCES ]]
	then
	    CONFIG="$CONFIG ]"
	    echo "PRODUCER NAME      : producer$i"
	else
	    CONFIG=$CONFIG,$C
            echo "PRODUCER NAME      : producer$i"
	fi
    fi

done

sed -i -e "s/{{traceAcceptAt}}/${CONFIG}/g" $CONFIG_FILE_TMP
cat $CONFIG_FILE_TMP | python -m json.tool >  $CONFIG_FILE_LOCAL

echo "

RELAY INSTANCES    : $RELAY_INSTANCES
PRODUCER INSTANCES : $PRODUCER_INSTANCES 
CONFIG PATH        : $CONFIG_FILE_LOCAL
----------------------------------------
"


exec /usr/local/rt-view/cardano-rt-view --port 8666 --config $CONFIG_FILE_LOCAL --static /usr/local/rt-view/static 
