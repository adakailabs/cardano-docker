#!/bin/bash

set -o errexit
set -o nounset



if [ $1 == "" ]; then
    echo "WARN: instances  not specified, using default"
    INSTANCES="1"
fi

INSTANCES=$1
LAST=$(($INSTANCES-1))
echo $LAST

# Current version
BASE_VERSION=$(cat version)
IMAGE_BASE="adakailabs/cardano-base:${BASE_VERSION}"
VERSION=$(cat ../cardano-base/version)
IMAGE="adakailabs/cardano-monitor:${VERSION}"

echo "building cardano image: ${IMAGE_BASE}"
CONFIG="["


for (( i=0; i<=$INSTANCES; i++ ))
do

    C=$(cat <<-END
        {
            "remoteAddr": {
                "tag": "RemoteSocket",
                "contents": [
                   "0.0.0.0",
                    "666$i"
                ]
            },
            "nodeName": "relay$i"
        }
END
     )

if [[ $i -eq 0 ]]
then
    CONFIG="$CONFIG $C"
else

    if [[ $i -eq $INSTANCES ]]
    then
	CONFIG="$CONFIG ]"
    else
	CONFIG=$CONFIG,$C
    fi
    
fi
    
done


echo $CONFIG  | python -m json.tool


#docker login 
#docker build  --file Dockerfile.cardano-monitor --build-arg CARDANO_NODE_BASE=${IMAGE_BASE} -t ${IMAGE} .
#docker push ${IMAGE}
