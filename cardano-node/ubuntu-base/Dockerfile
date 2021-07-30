FROM golang:latest as golang


FROM ubuntu:latest
LABEL maintainer="Adakailabs (info@adakailabs.com)"
ARG DEBIAN_FRONTEND=noninteractive

COPY --from=golang /usr/local/go /usr/local/go

RUN apt-get update \
        && apt-get upgrade -y \
	&& apt-get install -y \
	wget \
	git \
	tmux \
	emacs-nox \
	curl \
	python \
	jq \
	make \
	netcat \
	dnsutils \
	iotop \
	iftop \
	libnuma-dev \
	libcap2-bin \
	&& rm -rf /var/lib/apt/lists/*

# Setup default user environment
ARG USERNAME="lovelace"
ARG USERID="1000"
ARG GROUPID="1024"
ARG HOME="/home/${USERNAME}"

RUN groupadd -g $GROUPID -r $USERNAME \
	&& useradd --no-log-init -r --gid $GROUPID -u $USERID $USERNAME \
	&& mkdir /home/$USERNAME \
	&& echo "added new user" 

RUN git clone https://github.com/lagarciag/dotfiles.git /home/$USERNAME/.dotfiles \
	&& cd /home/$USERNAME/.dotfiles \
	&& USER=${USERNAME} ./setup.sh

RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME} \
	&& chown -R ${USERNAME}:${USERNAME} /usr/local \
	&& echo ${USERNAME}:${USERNAME} | chpasswd \
	&& chsh -s /bin/bash ${USERNAME}

#RUN test $(uname -m) != x86_64 || { \
#	wget -O go.tar.gz https://golang.org/dl/go1.16.3.linux-amd64.tar.gz;}

#RUN test $(uname -m) != aarch64 || { \
#	wget -O go.tar.gz https://golang.org/dl/go1.16.3.linux-arm64.tar.gz;}

#RUN tar -xvzf go.tar.gz && rm go.tar.gz && mv go /usr/local/go

SHELL ["/bin/bash", "-c"]

USER ${USERNAME}
