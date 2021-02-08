#!/bin/bash
# This script sets up the node for use as a stake pool.

set -e 

trap 'echo "$BASH_COMMAND"' DEBUG

# Login as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

ufw allow 3000
