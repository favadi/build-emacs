FROM debian:11

MAINTAINER Diep Pham

ARG DEBIAN_FRONTEND=noninteractiv

ADD build-emacs.sh /root/build-emacs.sh

RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
RUN /bin/bash -x /root/build-emacs.sh
