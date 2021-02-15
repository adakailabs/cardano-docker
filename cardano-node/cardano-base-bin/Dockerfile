FROM ubuntu:latest AS build
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

# Update and install the required packages
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
	automake \
	build-essential \
	pkg-config \
	libffi-dev \
	libgmp-dev \
	libssl-dev \
	libtinfo-dev \
	libsystemd-dev \
	zlib1g-dev \
	make \
	g++ \
	tmux \
	git \
	jq \
	wget \
	libncursesw5 \
	libtool \
	autoconf

WORKDIR /opt



# Build and install the IOHK fork of libsodium.
RUN git clone https://github.com/input-output-hk/libsodium \
	&& cd libsodium \
	&& git checkout 66f017f1 \
	&& ./autogen.sh \
	&& ./configure \
	&& make -j16 \
	&& make install
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Install cabal
#RUN wget https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz \
#	&& tar -xf cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz \
#	&& rm cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz cabal.sig \
#	&& mv cabal /usr/local/bin/ \
#	&& cabal update

ARG CARDANO_VERSION=1.25.0
ARG CARDANO_BUILD=5544808

COPY scripts/* /usr/local/bin/	  

RUN mkdir -p ./ctmp \
	&& cd ctmp \
	&& mkdir -p /etc/cardano/config \
	&& mkdir -p /opt/bin \
	&& wget https://hydra.iohk.io/build/$CARDANO_BUILD/download/1/cardano-node-${CARDANO_VERSION}-linux.tar.gz \
	&& tar -xvzf cardano-node-${CARDANO_VERSION}-linux.tar.gz \
	&& rm cardano-node-${CARDANO_VERSION}-linux.tar.gz \
	&& mv * /opt/bin/ \
	&& cd .. && rm -rf ctmp \
	&& download_config.sh 	  

# Install Prometheus Node Exporter
ARG VERSION=1.0.1
ARG DIRNAME="node_exporter-$VERSION.linux-amd64"
RUN cd /root \
	&& wget https://github.com/prometheus/node_exporter/releases/download/v$VERSION/$DIRNAME.tar.gz \
	&& tar xvfz $DIRNAME.tar.gz \
	&& mv $DIRNAME/node_exporter /usr/local/bin

ARG GOVERSION=1.15.6
RUN cd /tmp \
	&& wget https://golang.org/dl/go$GOVERSION.linux-amd64.tar.gz \
	&& tar -C /usr/local -xzf go$GOVERSION.linux-amd64.tar.gz \
        && rm go$GOVERSION.linux-amd64.tar.gz

ARG RTVIEWVERSION=0.3.0
RUN cd /tmp \
	&& wget https://github.com/input-output-hk/cardano-rt-view/releases/download/${RTVIEWVERSION}/cardano-rt-view-${RTVIEWVERSION}-linux-x86_64.tar.gz \
	&& mkdir /usr/local/rt-view \
	&& tar -C /usr/local/rt-view -xzf cardano-rt-view-${RTVIEWVERSION}-linux-x86_64.tar.gz \
	&& rm cardano-rt-view-${RTVIEWVERSION}-linux-x86_64.tar.gz

RUN cd /tmp && \
	wget http://argsparse.livna.org/bash-argsparse-1.8.tar.gz \
	&& tar -xvzf bash-argsparse-1.8.tar.gz \
	&& cp bash-argsparse-1.8/argsparse-completion.sh /usr/local/bin \
	&& cp bash-argsparse-1.8/argsparse.sh /usr/local/bin \
	&& rm -rf  bash-argsparse* 

RUN git clone https://gitlab.com/viper-staking/cardano-tools.git cardano \
	&& mv cardano /usr/local


