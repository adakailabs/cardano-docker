#!/bin/bash
# This script sets up the node for use as a stake pool.

trap 'echo "$BASH_COMMAND"' DEBUG

# Login as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

$GITHUB_USER="lagarciag"
$NEW_USER="lovelace"
$HOME="/home/${NEW_USER}"

echo "This script was developed on Ubuntu 20.04 "
echo "You are running the following version of Linux:"
head -1 /etc/os-release

# Update and install needed packages
apt update
apt -y upgrade
apt -y install git tmux ufw htop chrony curl rsync emacs-nox wget 

# Create the lovelace user (do not switch user)
groupadd -g 1024 lovelace
useradd -m -u 1000 -g lovelace -s /bin/bash lovelace
usermod -aG sudo lovelace
usermod -aG docker lovelace
passwd lovelace

USER=${NEW_USER} ./docker-install.sh 

git clone https://github.com/lagarciag/dotfiles.git ${HOME}/.dotfiles
cd ${HOME}/.dotfiles
USER=${NEW_USER} ./setup.sh./setup.sh


# Create the directories for the node
mkdir /home/lovelace/cardano-node

chown -R lovelace:lovelace /home/lovelace/cardano-node
chmod -R 774

# Install go compiler
export GOBIN=/usr/local/bin
export GOPATH=/tmp/go
goversion=1.15.6
wget https://golang.org/dl/go${goversion}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${goversion}.linux-amd64.tar.gz \
    && rm go${goversion}.linux-amd64.tar.gz  \
    && go get -v -d github.com/adakailabs/gocard \
    && cd ${GOPATH}/src/github.com/adakailabs/gocard \
    && make install 

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

# Setup SSH
curl https://github.com/${"GITHUB_USER"}.keys | tee -a ~/.ssh/authorized_keys
cp -r ~/.ssh /home/lovelace
chown -R lovelace:lovelace /home/lovelace/.ssh
sed -i.bak1 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
sed -i.bak2 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
echo 'AllowUsers lovelace' >> /etc/ssh/sshd_config
systemctl restart ssh

# Setup the firewall
ufw allow 2222/tcp  # ssh port
ufw enable

# Reboot
shutdown -r 0                                                                                                                                                                                                                         87        87,14         Bot
