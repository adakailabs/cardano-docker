FROM ubuntu:latest
LABEL maintainer="Adakailabs (info@adakailabs.com)"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
        && apt-get upgrade -y \
	&& apt-get install -y \
	wget \
	git \
	tmux \
	emacs-nox \
	curl \
        python \
	&& rm -rf /var/lib/apt/lists/*

# Setup default user environment
ARG USERNAME="lovelace"
ARG USERID="1000"
ARG GROUPID="1024"
RUN groupadd -g $GROUPID -r $USERNAME \
	&& useradd --no-log-init -r --gid $GROUPID -u $USERID $USERNAME \
	&& mkdir /home/$USERNAME

RUN export HOME=/home/${USERNAME}/ \
	&& git clone https://github.com/lagarciag/dotfiles.git ${HOME}/.dotfiles \
	&& cd ${HOME}/.dotfiles \
	&& ./setup.sh

RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME} \
	&& chown -R ${USERNAME}:${USERNAME} /usr/local \
	&& echo ${USERNAME}:${USERNAME} | chpasswd \
	&& chsh -s /bin/bash ${USERNAME}

SHELL ["/bin/bash", "-c"]

USER ${USERNAME}
