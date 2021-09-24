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
SHARE="/mnt/cardano-shares"
SUBNET="192.168.100.0/24"

echo "This script was developed on Ubuntu 20.04 "
echo "You are running the following version of Linux:"
head -1 /etc/os-release



export DEBIAN_FRONTEND=noninteractive

# Update and install needed packages
apt -y  update

sudo apt -y  install nfs-kernel-server
sudo mkdir -p  ${SHARE}
sudo chown nobody:nogroup ${SHARE}
sudo chmod -R 777 ${SHARE}
echo "${SHARE} ${SUBNET} (rw,sync,no_subtree_check)" >> /etc/exports
exportfs -a
ufw allow from ${SUBNET} to any port nfs
