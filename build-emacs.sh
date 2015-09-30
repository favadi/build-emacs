#!/bin/bash

# Build latest version of Emacs, version management with stow
# OS: Ubuntu 14.04 LTS and 15.04
# version: 24.5
# Toolkit: lucid

set -e

readonly version="24.5"

# edit this to your situation: libtiff4-dev for Ubuntu 14.04, or
# libtiff5-dev for Ubuntu 15.04+
libtiff_dev_version='libtiff5-dev'

# install dependencies
sudo apt-get install -y stow build-essential libx11-dev xaw3dg-dev \
     libjpeg-dev libpng12-dev libgif-dev ${libtiff_dev_version} libncurses5-dev \
     libxft-dev librsvg2-dev libmagickcore-dev libmagick++-dev \
     libxml2-dev libgpm-dev libghc-gconf-dev libotf-dev libm17n-dev \
     libgnutls-dev

# download source package
if [[ ! -d emacs-"$version" ]]; then
   wget http://ftp.gnu.org/gnu/emacs/emacs-"$version".tar.xz
   tar xvf emacs-"$version".tar.xz
fi

# build and install
sudo mkdir -p /usr/local/stow
cd emacs-"$version"
./configure \
    --with-xft \
    --with-x-toolkit=lucid

make
sudo make install prefix=/usr/local/stow/emacs-"$version"
cd /usr/local/stow

# the following code was added because of stow's (current) inability to handle
# conflicts with an already-existing /usr/local/share/info/dir file.
# so if /usr/local/share/info/dir is a file, and it is regular (not a directory
# or a device) and not a symlink, then move it
dirfile='/usr/local/share/info/dir'
if [ -e "$dirfile" -a -f "$dirfile" -a ! -L "$dirfile" ]; then
  cat <<EOF
Renaming an already-existing
   ${dirfile}
so that stow will be able to make a symlink from
   ${dirfile}
to
   /usr/local/stow/emacs-${version}/share/info/dir
EOF
  sudo mv -v ${dirfile} ${dirfile}-orig
fi

echo "Now running stow:"
sudo stow emacs-"$version"
