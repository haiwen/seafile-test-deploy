#!/bin/bash

set -e
set -x

sudo apt-get update -qq
sudo apt-get install -qq valac uuid-dev libevent-dev \
    libarchive-dev intltool re2c libjansson-dev libonig-dev

git submodule init
git submodule update --remote --merge

# build libevhtp
cd libevhtp
cmake .
make -j8
sudo make install
cd -

# build libzdb
cd libzdb
./bootstrap
./configure --without-postgresql --without-mysql
make -j8
sudo make install
cd -

# build libsearpc
cd libsearpc
./autogen.sh
./configure
make -j8
sudo make install
cd -

# build ccnet
cd ccnet
./autogen.sh
./configure --disable-client --enable-server
make -j8
sudo make install
cd -

# build seafile
cd seafile
./autogen.sh
./configure --disable-client --disable-fuse --enable-server
make -j8
sudo make install
cd -

# refresh shared library cache
sudo ldconfig
