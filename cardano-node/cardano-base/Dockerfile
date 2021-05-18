FROM ubuntu:latest
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

# Update and install the required packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
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
	&& make -j4 \
	&& make install
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Install cabal
ARG CABAL_VER="3.4.0.0"

RUN apt-get install libnuma-dev llvm -y 


RUN test $(uname -m) != x86_64 || { \
	wget -O cabal-install.tar.xz https://downloads.haskell.org/~cabal/cabal-install-$CABAL_VER/cabal-install-$CABAL_VER-x86_64-ubuntu-16.04.tar.xz ; }


RUN test $(uname -m) != aarch64 || { \
	wget -O cabal-install.tar.xz https://downloads.haskell.org/~cabal/cabal-install-$CABAL_VER/cabal-install-$CABAL_VER-aarch64-ubuntu-18.04.tar.xz  ; }

RUN tar -xvf cabal-install.tar.xz \
	&& rm cabal-install.tar.xz \
	&& ls -rtl cabal \
	&& mv cabal /usr/local/bin/ 

RUN cabal update
RUN cabal --version


# Install GHC
# 
RUN test $(uname -m) != x86_64 || { \
	wget -O ghc.tar.xz  https://downloads.haskell.org/ghc/8.10.2/ghc-8.10.2-x86_64-deb9-linux.tar.xz ; }

RUN test $(uname -m) != aarch64 || { \
	wget -O ghc.tar.xz  https://downloads.haskell.org/~ghc/8.10.2/ghc-8.10.2-aarch64-deb10-linux.tar.xz ; }


RUN tar -xf ghc.tar.xz \
        && ls -rtl \
	&& rm ghc.tar.xz \
	&& cd ghc-8.10.2 \
	&& ./configure \
	&& make -j4 install

# Install cardano node
ARG TAG=1.27.0
RUN git clone https://github.com/input-output-hk/cardano-node.git \
	&& cd cardano-node \
	&& git fetch --all --recurse-submodules --tags \
	&& git tag && git checkout tags/$TAG

RUN cd cardano-node \
	&& cabal configure --with-compiler=ghc-8.10.2 \
	&& echo "package cardano-crypto-praos" >>  cabal.project.local \
	&& echo "  flags: -external-libsodium-vrf" >>  cabal.project.local \
	&& cabal build -j4 all \
	&& mkdir /opt/bin/

RUN test $(uname -m) != x86_64 || { \
	cd cardano-node && cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.2/cardano-node-$TAG/x/cardano-node/build/cardano-node/cardano-node /opt/bin/ \
	&& cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.2/cardano-cli-$TAG/x/cardano-cli/build/cardano-cli/cardano-cli /opt/bin/ ;}

RUN test $(uname -m) != aarch64 || { \
	cd cardano-node && cp -p dist-newstyle/build/aarch64-linux/ghc-8.10.2/cardano-node-$TAG/x/cardano-node/build/cardano-node/cardano-node /opt/bin/ \
	&& cp -p dist-newstyle/build/aarch64-linux/ghc-8.10.2/cardano-cli-$TAG/x/cardano-cli/build/cardano-cli/cardano-cli /opt/bin/ ;}

# Install Prometheus Node Exporter
ARG VERSION=1.1.2

RUN test $(uname -m) != x86_64 || { \
	cd /root \
	&& wget https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.linux-amd64.tar.gz \
	&& tar -xvzf node_exporter-$VERSION.linux-amd64.tar.gz \
	&& mv node_exporter-$VERSION.linux-amd64/node_exporter /usr/local/bin && rm -rf node_exporter* 	;}

RUN test $(uname -m) != aarch64 || { \
	cd /root \
	&& wget https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.linux-arm64.tar.gz \
	&& tar -xvzf node_exporter-$VERSION.linux-arm64.tar.gz \
	&& mv node_exporter-$VERSION.linux-arm64/node_exporter /usr/local/bin && rm -rf node_exporter* 	;}

ARG RTVIEWVERSION=0.3.0
RUN test $(uname -m) != x86_64 || { \
	cd /tmp \
	&& wget https://github.com/input-output-hk/cardano-rt-view/releases/download/${RTVIEWVERSION}/cardano-rt-view-${RTVIEWVERSION}-linux-x86_64.tar.gz \
	&& mkdir /usr/local/rt-view \
	&& tar -C /usr/local/rt-view -xzf cardano-rt-view-${RTVIEWVERSION}-linux-x86_64.tar.gz \
	&& rm cardano-rt-view-${RTVIEWVERSION}-linux-x86_64.tar.gz ;}

RUN mkdir -p /etc/cardano
