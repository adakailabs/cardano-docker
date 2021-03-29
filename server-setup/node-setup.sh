#!/bin/bash

set -e 


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


for i in "${hosts[@]}"
do

    if [[ $i == "Sankokai-studio" ]];then
	if [[ $HOSTNAME == "Sankokai-studio" ]];then
	    Sankokai
	fi
    fi

    if [[ $i == $master00_ip ]];then
	if [[ $HOSTNAME == "roci-master00" ]];then
	    master00
	fi
    fi

    if [[ $i == $relay00_ip ]];then
	if [[ $HOSTNAME == "roci-relay00" ]];then
	    relay00
	fi
    fi

    if [[ $i == $relay01_ip ]];then
	if [[ $HOSTNAME == "roci-relay01" ]];then
	    relay01
	fi
    fi

    if [[ $i == $producer_ip ]];then
	if [[ $HOSTNAME == "roci-producer00" ]];then
	    producer00
	fi
    fi
    
done


