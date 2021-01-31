FROM adakailabs/ubuntu-base 
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

USER root

RUN groupadd --system prometheus \
	&& useradd -s /sbin/nologin --system -g prometheus prometheus \
 	&& mkdir /var/lib/prometheus

RUN mkdir -p /tmp/prometheus \
 	&& cd /tmp/prometheus \
 	&& curl -s  https://api.github.com/repos/prometheus/prometheus/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | wget -qi -  \
 	&& tar xvf prometheus*.tar.gz \
 	&& cd prometheus*/ \
	&& mv prometheus promtool /usr/local/bin/ \
	&& mkdir /etc/prometheus \
	&& mv console_libraries/ /etc/prometheus/ \
	&& mv consoles/ /etc/prometheus/ \
 	&& mkdir -p /usr/local/opt/prometheus \
	&& chown prometheus /usr/local/opt/prometheus 

RUN 	mkdir -p /prometheus \
        && chown prometheus:prometheus /prometheus

COPY prometheus.yml /etc/prometheus/
COPY entrypoint.sh /usr/local/bin

EXPOSE 9090

USER prometheus

# # Set cardano-node as the entrypoint and by default just print the version.

# CMD ["echo invalid"]
#FROM        quay.io/prometheus/busybox:latest
#FROM adakailabs/ubuntu-base:latest
#MAINTAINER  The Prometheus Authors <prometheus-developers@googlegroups.com>

#COPY prometheus/prometheus                             /bin/prometheus
#COPY prometheus/promtool                               /bin/promtool
#COPY prometheus/console_libraries/                     /etc/prometheus/
#COPY prometheus/consoles/                              /etc/prometheus/



EXPOSE     9090
#VOLUME     [ "/prometheus" ]
#WORKDIR    /prometheus


ENTRYPOINT ["entrypoint.sh"]
