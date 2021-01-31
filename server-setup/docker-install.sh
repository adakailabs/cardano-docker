##############################################################################
# Git/Docker Installation
# This script automatically downloads and installs docker and git
##############################################################################

set -e 

# Login as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

GITHUB_USER="lagarciag"
NEW_USER="lovelace"
HOME="/home/${NEW_USER}"



echo "This script was developed on Ubuntu 20.04"
echo "You are running the following version of Linux:"
head -1 /etc/os-release

# Move to current user home directory, where installation files will be hosted
cd ~

# Update OS packages and install prerequisite packages
sudo apt-get update && sudo apt-get upgrade && sudo apt-get install git curl wget -y 

# Download and install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh
echo "The following version of Docker has been installed:"
docker --version

# Add the current user to the docker group
echo "Adding user ${NEW_USER} to the docker group"
#sudo groupadd docker
sudo usermod -aG docker ${NEW_USER}

echo "Docker installation has been completed. You must reboot before running the setup script."
