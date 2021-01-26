FROM ubuntu:latest AS build
LABEL maintainer="Adakailabs Team (info@adakailabs.com)"

# Update and install the required packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y 

RUN sudo groupadd --system prometheus \
    && sudo useradd -s /sbin/nologin --system -g prometheus prometheus
