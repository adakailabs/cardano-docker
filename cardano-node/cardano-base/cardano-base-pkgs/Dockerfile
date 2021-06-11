FROM ubuntu:latest
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

# Update and install the required packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y 

RUN apt-get install -y \
	automake \
	build-essential \
	pkg-config \
	libffi-dev \
	libgmp-dev \
	libssl-dev \
	libtinfo-dev \
	libsystemd-dev \
	zlib1g-dev 

RUN apt-get install -y \
	make \
	g++ \
	tmux \
	git \
	jq \
	wget \
	libncursesw5 \
	libtool \
	autoconf \
	libnuma-dev \
	llvm

WORKDIR /opt
