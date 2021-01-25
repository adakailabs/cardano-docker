#!/bin/bash
set -e

# Start prometheus monitoring in the background
echo "Starting node_exporter..."
nohup node_exporter --web.listen-address=":9100" &

# Start cardano-node, passing all CMD args to it
echo "Starting cardano-node with arguments:"
cardano-node run \
	     --database-path /home/lovelace/cardano-node/db/ \
	     --socket-path /home/lovelace/cardano-node/db/node.socket \
	     --port 3001 \
	     --host-addr 0.0.0.0 \
	     --config /home/lovelace/cardano-node/config/config.json \
	     --topology /home/lovelace/cardano-node/config/topology.json

