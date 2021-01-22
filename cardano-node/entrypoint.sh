#!/bin/bash
set -e

# Start prometheus monitoring in the background
echo "Starting node_exporter..."
nohup node_exporter --web.listen-address=":9100" &

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

nohup /usr/local/rt-view/cardano-rt-view --config /home/lovelace/cardano-node/rt-view --static /usr/local/rt-view/cardano-rt-view/static

# Start cardano-node, passing all CMD args to it
echo "Starting cardano-node with arguments:"
echo "$@"
exec cardano-node $@
