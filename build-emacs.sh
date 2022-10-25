#!/bin/bash

# Build latest version of Emacs, version management with stow
# OS: Debian 11
# Toolkit: gtk3

set -euo pipefail

readonly version="28.2"

export DEBIAN_FRONTEND="noninteractive"

# install dependencies
sudo apt-get update
sudo apt-get install -y \
	stow wget \
	build-essential \
	libgccjit-10-dev \
	libgif-dev \
	libgnutls28-dev \
	libgpm-dev \
	libgtk-3-dev \
	libjansson-dev \
	libjpeg-dev \
	liblcms2-dev \
	libm17n-dev \
	libncurses5-dev \
	libotf-dev \
	librsvg2-dev \
	libtiff5-dev \
	libx11-dev \
	libxml2-dev \
	libxpm-dev \
	pkg-config

# download source package
if [[ ! -d emacs-"$version" ]]; then
	wget http://ftp.gnu.org/gnu/emacs/emacs-"$version".tar.xz
	tar xvf emacs-"$version".tar.xz
fi

# create /usr/local subdirectories
sudo mkdir -p /usr/local/{bin,etc,games,include,lib,libexec,man,sbin,share,src,stow}

# build and install
cd emacs-"$version"
./configure \
	--with-cairo \
	--with-harfbuzz \
	--with-modules \
	--with-x-toolkit=gtk3 \
	--with-native-compilation
make

sudo make \
	install-arch-dep \
	install-arch-indep \
	prefix=/usr/local/stow/emacs-"$version"

cd /usr/local/stow
sudo stow emacs-"$version"
