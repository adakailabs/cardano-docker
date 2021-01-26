# FROM adakailabs/ubuntu-base 
# LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

# USER root
# # Update and install the required packages
# ARG DEBIAN_FRONTEND=noninteractive
# RUN apt-get update && apt-get install curl wget -y 

# RUN groupadd --system prometheus \
# 	&& useradd -s /sbin/nologin --system -g prometheus prometheus \
# 	&& mkdir /var/lib/prometheus \
# 	&& mkdir -p /tmp/prometheus \
# 	&& cd /tmp/prometheus \
# 	&& curl -s  https://api.github.com/repos/prometheus/prometheus/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | wget -qi -  \
# 	&& tar xvf prometheus*.tar.gz \
# 	&& cd prometheus*/ \
# 	&& mv prometheus promtool /usr/local/bin/ \
# 	&& mkdir /etc/prometheus \
# 	&& mkdir -p /usr/local/opt/prometheus \
# 	&& chown prometheus /usr/local/opt/prometheus

# COPY prometheus.yml /etc/prometheus/
# COPY entrypoint.sh /usr/local/bin

# EXPOSE 9090

# USER prometheus

# # Set cardano-node as the entrypoint and by default just print the version.
# ENTRYPOINT ["entrypoint.sh"]
# CMD ["echo invalid"]

FROM prom/prometheus
ADD prometheus.yml /etc/prometheus/

