#!/bin/bash

set -e
set -x

git submodule init
git submodule update --remote --merge

# build libevhtp
cd libevhtp
cmake -DEVHTP_DISABLE_SSL=ON -DEVHTP_BUILD_SHARED=OFF .
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

# build seafile
cd seafile-server

git fetch origin 11.0:11.0 
git checkout 11.0

cd ci/
./install-deps.sh
cd -
./autogen.sh
./configure --disable-client --disable-fuse --enable-server
make -j8
sudo make install
cd -

# refresh shared library cache
sudo ldconfig
