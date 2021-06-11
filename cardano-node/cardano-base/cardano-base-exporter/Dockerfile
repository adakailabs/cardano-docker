FROM adakailabs/multi_cardano_base_pkgs
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

# Update and install the required packages
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /opt


ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

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

