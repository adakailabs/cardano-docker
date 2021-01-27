#!/bin/bash

set -o errexit
set -o nounset



if [ $1 == "" ]; then
    echo "WARN: instances  not specified, using default"
    RELAY_INSTANCES="1"
fi

RELAY_INSTANCES=$1
LAST=$(($RELAY_INSTANCES-1))
echo $LAST

# Current version
BASE_VERSION=$(cat version)
IMAGE_BASE="adakailabs/cardano-base:${BASE_VERSION}"
VERSION=$(cat ../cardano-base/version)
IMAGE="adakailabs/cardano-monitor:${VERSION}"

echo "building cardano image: ${IMAGE_BASE}"
CONFIG="["


for (( i=0; i<=$RELAY_INSTANCES; i++ ))
do

    C="{\"remoteAddr\": {\"tag\": \"RemoteSocket\",\"contents\": [\"0.0.0.0\",\"666$i\"]},\"nodeName\": \"relay$i\"}"

    if [[ $i -eq 0 ]]
    then
	CONFIG="$CONFIG $C"
    else

	if [[ $i -eq $RELAY_INSTANCES ]]
	then
	    CONFIG="$CONFIG ]"
	else
	    CONFIG=$CONFIG,$C
	fi
    fi
done


rm -rf rt-view-config_tmp
cp -r  rt-view-config rt-view-config_tmp

sed -i -e "s/{{traceAcceptAt}}/${CONFIG}/g" rt-view-config_tmp/cardano-rt-view.json
cat  rt-view-config_tmp/cardano-rt-view.json | python -m json.tool > rt-view-config_tmp/cardano-rt-view.json.new
mv rt-view-config_tmp/cardano-rt-view.json.new rt-view-config_tmp/cardano-rt-view.json 

echo "done"

docker login 
docker build  --file Dockerfile.cardano-monitor --build-arg CARDANO_NODE_BASE=${IMAGE_BASE} -t ${IMAGE} .
rm -rf rt-view-config_tmp
docker push ${IMAGE}
