#!/bin/bash

# Build latest version of Emacs, version management with stow
# OS: Ubuntu 14.04 LTS
# version: 24.5
# Toolkit: lucid

set -e

readonly version="24.5"

# install dependencies (you may need libtiff4-dev instead of libtiff5-dev)
sudo apt-get install -y stow build-essential libx11-dev xaw3dg-dev \
     libjpeg-dev libpng12-dev libgif-dev libtiff5-dev libncurses5-dev \
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
  echo "Note: There is already a pre-existing dir file at"
  echo "$dirfile and I am about to run stow. But"
  echo "stow will need to symlink to that location from"
  echo "/usr/local/stow/emacs-${version}/share/info/dir
  echo "be able to if there is a file already existing there."
  echo "So for now, to resolve that potential conflict, I am renaming"
  echo "${dirfile} to ${dirfile}-orig."
  echo "You may want to resolve or merge the two dir files manually later."
  echo "Renaming:"
  sudo mv -v ${dirfile} ${dirfile}-orig
fi

echo "Now running stow:"
sudo stow emacs-"$version"
