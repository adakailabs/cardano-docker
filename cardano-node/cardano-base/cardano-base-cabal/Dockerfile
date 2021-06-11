FROM adakailabs/multi_cardano_base_pkgs
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

# Update and install the required packages
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /opt


ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Install cabal
ARG CABAL_VER="3.4.0.0"

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

