#!/bin/bash

docker node update --label-add com.adakailabs.monitor=true master00
docker node update --label-add com.adakailabs.relay0=true relay00
docker node update --label-add com.adakailabs.relay1=true relay01
docker node update --label-add com.adakailabs.producer0=true producer00

master00_ip="10.116.0.2"
relay00_ip="10.116.0.3"
relay01_ip="10.116.0.5"
producer_ip="10.116.0.4"

hosts=($master00_ip $relay00_ip $relay01_ip $producer_ip "Sankokai-studio")

function set_all {
    	echo sudo ufw disable
	echo sudo ufw default deny incoming
	echo sudo ufw default allow outgoing
	echo sudo ufw allow 2222
}


function set_docker {
    for i in "${hosts[@]}"
    do
	echo sudo ufw allow from $i to any port 2376/tcp
	echo sudo ufw allow from $i to any port 2377/tcp
	echo sudo ufw allow from $i to any port 7946/tcp
	echo sudo ufw allow from $i to any port 7946/udp
	echo sudo ufw allow from $i to any port 4789/udp
	
    done
}



function Sankokai {
    echo $HOSTNAME
    set_all
    set_docker
}


function master00 {
    	echo "this is ${HOSTNAME}"
	set_all
	set_docker

	# Prometheus
	sudo ufw allow 12700/tcp
	sudo ufw allow 9100/tcp
	sudo ufw allow 8666/tcp
	# Grafana
	ufw allow 3666/tcp
	
}


function relay00 {
    	echo "this is ${HOSTNAME}"
	set_all
	set_docker

	ufw allow 3000/tcp
	
	
}


function relay01 {
    	echo "this is ${HOSTNAME}"
	set_all
	set_docker

	ufw allow 3001/tcp
	
	sudo ufw enable
}


function relay00 {
    	echo "this is ${HOSTNAME}"
	set_all
	set_docker
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

    sudo ufw enable
    
done


