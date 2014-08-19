#!/bin/bash

set -e
set -x

sudo apt-get update -qq
sudo apt-get install -qq valac uuid-dev libevent-dev \
    libarchive-dev intltool re2c libjansson-dev libonig-dev

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

# install seahub deps
sudo pip install python-dateutil chardet six Image \
    Django==1.5.8 Djblets==0.6.14 \
    --allow-all-external --allow-unverified Djblets \
    --allow-unverified PIL

# install phantomjs binary for linux x86_64
curl -L -o /tmp/phantomjs.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2
tar -C /tmp -xf /tmp/phantomjs.tar.bz2
sudo install -m 755 /tmp/phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/bin/phantomjs

# refresh shared library cache
sudo ldconfig
