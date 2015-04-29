#!/bin/bash

# Build latest version of Emacs, version management with stow
# OS: Ubuntu 14.04 LTS
# version: 24.5
# Toolkit: lucid

set -e

readonly version="24.5"

# install dependencies
sudo apt-get install -y stow build-essential libx11-dev xaw3dg-dev \
     libjpeg-dev libpng12-dev libgif-dev libtiff4-dev libncurses5-dev \
     libxft-dev librsvg2-dev libmagickcore-dev libmagick++-dev \
     libxml2-dev libgpm-dev libghc-gconf-dev libotf-dev libm17n-dev \
     libgnutls-dev

# download source package
if [[ ! -d emacs-"$version" ]]; then
   wget http://ftp.gnu.org/gnu/emacs/emacs-"$version".tar.xz
   tar xvf emacs-"$version".tar.xz
fi

# buil and install
sudo mkdir /usr/local/stow
cd emacs-"$version"
./configure \
    --with-xft \
    --with-x-toolkit=lucid
make
sudo make install prefix=/usr/local/stow/emacs-"$version"
cd /usr/local/stow
sudo stow emacs-"$version"
