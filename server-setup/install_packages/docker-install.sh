#!/bin/bash
set -e 

service="docker"
if [ -f "/etc/init.d/$service" ]; then
    exit 0
fi


# Download and install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh
echo "The following version of Docker has been installed:"
docker --version

# Add the current user to the docker group
echo "Adding user ${NEW_USER} to the docker group"
groupadd -f docker
usermod -aG docker lovelace

echo "Docker installation has been completed. You must reboot before running the setup script."

