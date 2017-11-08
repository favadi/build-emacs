#!/bin/bash

# Build latest version of Emacs, version management with stow
# OS: Ubuntu 14.04 LTS and newer
# Toolkit: gtk3

set -eu

readonly version="25.3"

# install dependencies
sudo apt-get -qq update
sudo apt-get -qq install -y stow build-essential libx11-dev \
     libjpeg-dev libgif-dev libtiff5-dev libncurses5-dev \
     libxft-dev librsvg2-dev libmagickcore-dev libmagick++-dev \
     libxml2-dev libgpm-dev libotf-dev libm17n-dev \
     libgtk-3-dev libwebkitgtk-3.0-dev libxpm-dev wget

# from Ubuntu 16.10, libgnutls-dev, libpng12-dev is no longer available
sudo apt-get -qq install libgnutls-dev libpng12-dev || \
    sudo apt-get -qq install libgnutls28-dev libpng-dev

# download source package
if [[ ! -d emacs-"$version" ]]; then
   wget http://ftp.gnu.org/gnu/emacs/emacs-"$version".tar.xz
   tar xvf emacs-"$version".tar.xz
fi

# create /usr/local subdirectories
sudo mkdir -p /usr/local/{bin,etc,games,include,lib,libexec,sbin,share,src}

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
