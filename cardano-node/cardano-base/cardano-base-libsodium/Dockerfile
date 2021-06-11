FROM adakailabs/multi_cardano_base_pkgs
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

# Update and install the required packages
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /opt

# Build and install the IOHK fork of libsodium.
RUN git clone https://github.com/input-output-hk/libsodium \
	&& cd libsodium \
	&& git checkout 66f017f1 \
	&& ./autogen.sh \
	&& ./configure \
	&& make -j4 \
	&& make install

