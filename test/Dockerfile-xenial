FROM ubuntu:xenial

MAINTAINER Diep Pham

ADD build-emacs.sh /root/build-emacs.sh

# Ubuntu Xenial docker image doesn't have sudo installed
RUN apt-get update && apt-get install -qqy sudo && rm -rf /var/lib/apt/lists/*
RUN /bin/bash -x /root/build-emacs.sh
