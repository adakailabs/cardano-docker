if [ -z "$1" ]; then
    TAG="latest"
else
    TAG=$1
fi
docker login 
docker build -t adakailabs/cardano-node:$TAG .
docker push adakailabs/cardano-node:$TAG
