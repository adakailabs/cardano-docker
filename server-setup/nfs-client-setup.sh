#!/bin/bash
# This script sets up the node for use as a stake pool.

set -e 

trap 'echo "$BASH_COMMAND"' DEBUG

# Login as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

GITHUB_USER="lagarciag"
NEW_USER="lovelace"
HOME="/home/${NEW_USER}"
SHARE_CLIENT="/mnt/cardano_shares"
SHARE_SERVER="/mnt/cardano-shares"
SUBNET="192.168.100.0/24"
SERVER="192.168.100.57"

echo "This script was developed on Ubuntu 20.04 "
echo "You are running the following version of Linux:"
head -1 /etc/os-release

export DEBIAN_FRONTEND=noninteractive

# Update and install needed packages
apt -y  update

sudo apt -y  install nfs-common
sudo mkdir -p  ${SHARE_CLIENT}
sudo mount 192.168.100.57:${SHARE_SERVER} ${SHARE_CLIENT}

echo "192.168.100.57:${SHARE_SERVER}    ${SHARE_CLIENT}    nfs    defaults    0 0" >> /etc/fstab



