##############################################################################
# Git/Docker Installation
# This script automatically downloads and installs docker and git
##############################################################################

set -e 

# Login as root
#if [ "$EUID" -ne 0 ]
#  then echo "Please run as root"
#  exit
#fi

GITHUB_USER="lagarciag"
NEW_USER="ubuntu"
HOME="/home/${NEW_USER}"

echo "This script was developed on Ubuntu 20.04"
echo "You are running the following version of Linux:"
head -1 /etc/os-release

# Move to current user home directory, where installation files will be hosted
cd ~

# Update OS packages and install prerequisite packages
sudo apt-get update && sudo apt-get upgrade

sudo curl -sfL https://get.k3s.io | sh -

