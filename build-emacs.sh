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
	stow \
	build-essential \
	libx11-dev \
	libjpeg-dev libgif-dev libtiff5-dev libncurses5-dev \
	libxft-dev librsvg2-dev libmagickcore-dev libmagick++-dev \
	libxml2-dev libgpm-dev libotf-dev libm17n-dev \
	libgtk-3-dev libwebkitgtk-3.0-dev libxpm-dev wget \
	libgnutls28-dev libpng-dev

# download source package
if [[ ! -d emacs-"$version" ]]; then
	wget http://ftp.gnu.org/gnu/emacs/emacs-"$version".tar.xz
	tar xvf emacs-"$version".tar.xz
fi

# create /usr/local subdirectories
sudo mkdir -p /usr/local/{bin,etc,games,include,lib,libexec,man,sbin,share,src}

# build and install
sudo mkdir -p /usr/local/stow
cd emacs-"$version"
./configure \
	--with-xft \
	--with-x-toolkit=gtk3

make
sudo make \
	install-arch-dep \
	install-arch-indep \
	prefix=/usr/local/stow/emacs-"$version"

cd /usr/local/stow
sudo stow emacs-"$version"
