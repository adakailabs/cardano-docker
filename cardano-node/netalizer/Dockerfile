FROM ubuntu:latest
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

# Update and install the required packages
ARG DEBIAN_FRONTEND=noninteractive

#10 5.498 E: Unable to locate package bind-tools
#10 5.498 E: Unable to locate package conntrack-tools
#10 5.498 E: Unable to locate package drill
#10 5.498 E: Unable to locate package iputils
#10 5.498 E: Unable to locate package libc6-compat
#10 5.498 E: Unable to locate package liboping
#10 5.498 E: Unable to locate package net-snmp-tools
#10 5.498 E: Unable to locate package nmap-nping
#10 5.498 E: Unable to locate package py3-pip
#10 5.498 E: Unable to locate package py3-setuptools
#10 5.498 E: Unable to locate package websocat



RUN apt-get update && apt-get install -y \
	iputils-ping \
	make \
	tmux \
	git \
	jq \
	wget \
	autoconf \
	bird \
	bridge-utils \
	curl \
	dhcping \
	ethtool \
	file\
	fping \
	iftop \
	iperf \
	iproute2 \
	ipset \
	iptraf-ng \
	ipvsadm \
	jq \
	mtr \
	netcat-openbsd \
	nftables \
	ngrep \
	nmap \
	openssl \
	socat \
	strace \
	tcpdump \
	tcptraceroute \
	tshark \
	util-linux \
	git 

WORKDIR /opt
