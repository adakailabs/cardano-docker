FROM adakailabs/multi_cardano_base_pkgs
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

# Update and install the required packages
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /opt

ARG GHC_VER=8.10.5

ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Install GHC
RUN test $(uname -m) != x86_64 || { \
	wget -O ghc.tar.xz  https://downloads.haskell.org/ghc/$GHC_VER/ghc-$GHC_VER-x86_64-deb9-linux.tar.xz ; }

RUN test $(uname -m) != aarch64 || { \
	wget -O ghc.tar.xz  https://downloads.haskell.org/~ghc/$GHC_VER/ghc-$GHC_VER-aarch64-deb10-linux.tar.xz ; }


RUN tar -xf ghc.tar.xz \
        && ls -rtl \
	&& rm ghc.tar.xz \
	&& cd ghc-8.10.5 \
	&& ./configure \
	&& make -j4 install

RUN find /usr -name "ghc*"

