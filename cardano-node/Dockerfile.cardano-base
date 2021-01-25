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
RUN wget https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz \
	&& tar -xf cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz \
	&& rm cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz cabal.sig \
	&& mv cabal /usr/local/bin/ \
	&& cabal update

# Install GHC
RUN wget https://downloads.haskell.org/ghc/8.10.2/ghc-8.10.2-x86_64-deb9-linux.tar.xz \
	&& tar -xf ghc-8.10.2-x86_64-deb9-linux.tar.xz \
	&& rm ghc-8.10.2-x86_64-deb9-linux.tar.xz \
	&& cd ghc-8.10.2 \
	&& ./configure \
	&& make install

# Install cardano node
ARG TAG=1.24.2
RUN git clone https://github.com/input-output-hk/cardano-node.git \
	&& cd cardano-node \
	&& git fetch --all --recurse-submodules --tags \
	&& git tag && git checkout tags/$TAG \
	&& cabal configure --with-compiler=ghc-8.10.2 \
	&& echo "package cardano-crypto-praos" >>  cabal.project.local \
	&& echo "  flags: -external-libsodium-vrf" >>  cabal.project.local \
	&& cabal build -j16 all \
	&& mkdir /opt/bin/ \
	&& cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.2/cardano-node-$TAG/x/cardano-node/build/cardano-node/cardano-node /opt/bin/ \
	&& cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.2/cardano-cli-$TAG/x/cardano-cli/build/cardano-cli/cardano-cli /opt/bin/

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

RUN mkdir -p /etc/cardano
