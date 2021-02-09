#!/bin/bash
# This script sets up the node for use as a stake pool.

set -e 

GITHUB_USER="lagarciag"
NEW_USER="lovelace"
HOME="/home/${NEW_USER}"


trap 'echo "$BASH_COMMAND"' DEBUG

# Login as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


# Setup SSH
curl https://github.com/${GITHUB_USER}.keys | tee -a $HOME/.ssh/authorized_keys
chown -R lovelace:lovelace $HOME/.ssh
sed -i.bak1 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
sed -i.bak2 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
echo 'AllowUsers lovelace' >> /etc/ssh/sshd_config
systemctl restart ssh

# Setup the firewall
ufw default deny incoming
ufw default allow outgoing

ufw allow 2222/tcp  # ssh port

# docker swarn related
ufw allow 2376/tcp
ufw allow 2377/tcp
ufw allow 7946/tcp
ufw allow 7946/udp
ufw allow 4789/udp

ufw enable
