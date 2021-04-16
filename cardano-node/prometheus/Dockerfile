FROM adakailabs/ubuntu-base 
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

USER root

#RUN groupadd --system prometheus \
#	&& useradd -s /sbin/nologin --system -g prometheus prometheus \
# 	&& mkdir /var/lib/prometheus

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
	&& mkdir /var/lib/prometheus \
	&& chown lovelace:lovelace /usr/local/opt/prometheus \
	&& chown lovelace:lovelace /var/lib/prometheus 

RUN 	mkdir -p /prometheus \
        && chown lovelace:lovelace /prometheus

COPY prometheus.yml /etc/prometheus/
#COPY entrypoint.sh /usr/local/bin

EXPOSE 9090

COPY tmp/gocnode /usr/local/bin/

USER lovelace

EXPOSE     9090

ENTRYPOINT ["gocnode"]

