#!/bin/bash

set -e 


master00_ip="10.116.0.2"
relay00_ip="10.116.0.3"
relay01_ip="10.116.0.5"
producer_ip="10.116.0.4"

master00_ip2="206.189.201.90"
relay00_ip2="167.99.239.161"
relay01_ip2="104.248.239.167"
producer_ip2="206.189.191.231"


hosts=($master00_ip $relay00_ip $relay01_ip $producer_ip $master00_ip2 $relay00_ip2 $relay01_ip2 $producer_ip2)

function set_all {
    sudo ufw disable
    sudo ufw reset 
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow 2222
}


function set_docker {
    for i in "${hosts[@]}"
    do
	sudo ufw allow from $i to any port 2376 proto tcp
	sudo ufw allow from $i to any port 2377 proto tcp
	sudo ufw allow from $i to any port 7946 proto tcp
	sudo ufw allow from $i to any port 7946 proto tcp
	sudo ufw allow from $i to any port 4789 proto tcp
	sudo ufw allow from $i to any port 7946 proto udp
	sudo ufw allow from $i to any port 4789 proto udp

    done
}



function Sankokai {
    echo $HOSTNAME
    set_all
    set_docker
}


function master00 {

    docker node update --label-add com.adakailabs.monitor=true master00
    docker node update --label-add com.adakailabs.relay0=true relay00
    docker node update --label-add com.adakailabs.relay1=true relay01
    docker node update --label-add com.adakailabs.producer0=true producer00
    
    
    echo "this is ${HOSTNAME}"
    set_all
    set_docker
    
    # Prometheus
    sudo ufw allow 12700/tcp
    sudo ufw allow 9100/tcp
    sudo ufw allow 8666/tcp
    # Grafana
    sudo ufw allow 3666/tcp
    
    sudo ufw enable
    
}


function relay00 {
    	echo "this is ${HOSTNAME}"
	set_all
	set_docker

	sudo ufw allow 3000/tcp

	sudo ufw enable
	
}


function relay01 {
    	echo "this is ${HOSTNAME}"
	set_all
	set_docker

	sudo ufw allow 3001/tcp
	
	sudo ufw enable
}


function producer00 {
    	echo "this is ${HOSTNAME}"
	set_all
	set_docker

	sudo ufw enable
}


for i in "${hosts[@]}"
do

    if [[ $i == "Sankokai-studio" ]];then
	if [[ $HOSTNAME == "Sankokai-studio" ]];then
	    Sankokai
	fi
    fi

    if [[ $i == $master00_ip ]];then
	if [[ $HOSTNAME == "master00" ]];then
	    master00
	fi
    fi

    if [[ $i == $relay00_ip ]];then
	if [[ $HOSTNAME == "relay00" ]];then
	    relay00
	fi
    fi

    if [[ $i == $relay01_ip ]];then
	if [[ $HOSTNAME == "relay01" ]];then
	    relay01
	fi
    fi

    if [[ $i == $producer_ip ]];then
	if [[ $HOSTNAME == "producer00" ]];then
	    producer00
	fi
    fi
    
done


