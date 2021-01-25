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

exec /usr/local/rt-view/cardano-rt-view --port 8666 --config /etc/cardano/rt-view/cardano-rt-view.json --static /usr/local/rt-view/static 
