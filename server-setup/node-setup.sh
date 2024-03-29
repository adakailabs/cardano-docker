#!/bin/bash

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



master00_ip="10.120.0.3"
relay00_ip="10.120.0.6"
relay01_ip="10.120.0.4"
producer_ip="10.120.0.5"

master00_ip2="138.68.22.117"
relay00_ip2="138.68.57.81"
relay01_ip2="138.68.56.11"
producer_ip2="138.68.49.232"


hosts=($master00_ip $relay00_ip $relay01_ip $producer_ip $master00_ip2 $relay00_ip2 $relay01_ip2 $producer_ip2)

function set_all {
    ufw disable
    ufw reset 
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow 2222
}


function set_docker {
    for i in "${hosts[@]}"
    do
	ufw allow from $i to any port 2376 proto tcp
	ufw allow from $i to any port 2377 proto tcp
	ufw allow from $i to any port 7946 proto tcp
	ufw allow from $i to any port 7946 proto tcp
	ufw allow from $i to any port 4789 proto tcp
	ufw allow from $i to any port 7946 proto udp
	ufw allow from $i to any port 4789 proto udp

    done
}



function Sankokai {
    echo $HOSTNAME
    set_all
    set_docker
}


function master00 {

    #docker node update --label-add com.adakailabs.monitor=true master00
    #docker node update --label-add com.adakailabs.relay0=true relay00
    #docker node update --label-add com.adakailabs.relay1=true relay01
    #docker node update --label-add com.adakailabs.producer0=true producer00
    
    
    echo "this is ${HOSTNAME}"
    set_all
    set_docker
    
    # Prometheus
    ufw allow 12700/tcp
    ufw allow 9100/tcp
    ufw allow 8666/tcp
    # Grafana
    ufw allow 3666/tcp
    
    ufw enable
    
}


function relay00 {
    	echo "this is ${HOSTNAME}"
	set_all
	set_docker

	ufw allow 3000/tcp

	ufw enable
	
}


function relay01 {
    	echo "this is ${HOSTNAME}"
	set_all
	set_docker

	ufw allow 3001/tcp
	
	ufw enable
}


function producer00 {
    	echo "this is ${HOSTNAME}"
	set_all
	set_docker

	ufw enable
}

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh


# Setup SSH
curl https://github.com/${GITHUB_USER}.keys | tee -a $HOME/.ssh/authorized_keys
chown -R lovelace:lovelace $HOME/.ssh
sed -i.bak1 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
sed -i.bak2 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
echo 'AllowUsers lovelace' >> /etc/ssh/sshd_config
systemctl restart ssh



