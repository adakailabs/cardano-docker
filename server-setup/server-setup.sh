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


echo "This script was developed on Ubuntu 20.04 "
echo "You are running the following version of Linux:"
head -1 /etc/os-release

# Update and install needed packages
apt update
DEBIAN_FRONTEND=noninteractive apt -y upgrade
DEBIAN_FRONTEND=noninteractive apt -y install git tmux ufw htop chrony curl rsync emacs-nox wget 

wget http://argsparse.livna.org/bash-argsparse-1.8.tar.gz \
    && tar -xvzf bash-argsparse-1.8.tar.gz \
    && cp bash-argsparse-1.8/argsparse-completion.sh /usr/local/bin \
    && cp bash-argsparse-1.8/argsparse.sh /usr/local/bin \
    && rm -rf  bash-argsparse* 

# Create the lovelace user (do not switch user)
groupadd -g 1024 lovelace
useradd -m -u 1000 -g lovelace -s /bin/bash lovelace
usermod -aG sudo lovelace
passwd lovelace

# Create the directories for the node
mkdir -p $HOME/cardano-node
mkdir -p $HOME/.ssh
mkdir -p $HOME/grafana/etc/grafana
mkdir -p $HOME/grafana/usr/share/grafana
mkdir -p $HOME/grafana/var/log/grafana
mkdir -p $HOME/grafana/var/lib/grafana/plugins
mkdir -p $HOME/grafana/etc/grafana/provisioning


USER=${NEW_USER} ./docker-install.sh 

git clone https://github.com/lagarciag/dotfiles.git ${HOME}/.dotfiles
cd ${HOME}/.dotfiles
USER=${NEW_USER} HOME=${HOME} ./setup.sh



chown -R lovelace:lovelace $HOME/cardano-node
chmod -R 774 $HOME/cardano-node

# Configure chrony (use the Google time server)
cat > /etc/chrony/chrony.conf << EOM
server time.google.com prefer iburst minpoll 4 maxpoll 4
keyfile /etc/chrony/chrony.keys
driftfile /var/lib/chrony/chrony.drift
maxupdateskew 5.0
rtcsync
makestep 0.1 -1
leapsectz right/UTC
local stratum 10
EOM
timedatectl set-timezone UTC
systemctl stop systemd-timesyncd
systemctl disable systemd-timesyncd
systemctl restart chrony
hwclock -w

# Setup the Swap File
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
cp /etc/fstab /etc/fstab.back
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

/root/cardano-docker/server-setup/node-setup.sh

# Reboot
shutdown -r 0                                                                                                                                                                                              
