#!/bin/bash

# Build latest version of Emacs, version management with stow
# OS: Ubuntu 14.04 LTS and newer
# Toolkit: gtk3

set -eu

readonly version="26.1"

# install dependencies
sudo zypper install --no-confirm stow xorg-x11-devel gtk3-devel libgnutls-devel

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
    --with-x-toolkit=gtk3 \
    --with-jpeg=no \
    --with-gif=no \
    --with-tiff=no

make
sudo make \
    install-arch-dep \
    install-arch-indep \
    prefix=/usr/local/stow/emacs-"$version"

cd /usr/local/stow
sudo stow emacs-"$version"
