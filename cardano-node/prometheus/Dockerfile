FROM adakailabs/multi_ubuntu_base:latest
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

USER root

COPY tmp/gocnode_* /tmp/

#RUN groupadd --system prometheus \
#	&& useradd -s /sbin/nologin --system -g prometheus prometheus \
# 	&& mkdir /var/lib/prometheus

RUN test $(uname -m) != x86_64 || { \
	mv /tmp/gocnode_amd64 /usr/local/bin/gocnode ;}

RUN test $(uname -m) != aarch64 || { \
	mv /tmp/gocnode_arm64 /usr/local/bin/gocnode ;}

RUN test $(uname -m) != x86_64 || { \
	wget https://github.com/prometheus/prometheus/releases/download/v2.29.2/prometheus-2.29.2.linux-amd64.tar.gz ;}
	#&& curl -s  https://api.github.com/repos/prometheus/prometheus/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | wget -qi - \

RUN test $(uname -m) != aarch64 || { \
        wget https://github.com/prometheus/prometheus/releases/download/v2.29.2/prometheus-2.29.2.linux-arm64.tar.gz ;}
	#&& curl -s  https://api.github.com/repos/prometheus/prometheus/releases/latest | grep browser_download_url | grep linux-arm64 | cut -d '"' -f 4 | wget -qi - ;}


RUN     mkdir -p /tmp/prometheus \
	&& mv  prometheus*.tar.gz /tmp/prometheus \
	&& cd /tmp/prometheus \
 	&& tar xvf prometheus*.tar.gz \
 	&& cd prometheus*/ \
	&& mv prometheus promtool /usr/local/bin/ \
	&& mkdir /etc/prometheus \
	&& mv console_libraries/ /etc/prometheus/ \
	&& mv consoles/ /etc/prometheus/ \
	&& mkdir -p /usr/local/opt/prometheus \
	&& mkdir /var/lib/prometheus \
	&& chown lovelace:lovelace /usr/local/opt/prometheus \
	&& chown lovelace:lovelace /var/lib/prometheus 

RUN 	mkdir -p /prometheus \
        && chown lovelace:lovelace /prometheus

COPY prometheus.yml /etc/prometheus/
#COPY entrypoint.sh /usr/local/bin

EXPOSE 9090

USER lovelace

ENTRYPOINT ["gocnode"]

