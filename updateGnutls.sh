#!/bin/bash

# prep
sudo apt-get install libgmp-dev autogen pkg-config make m4

# nettle .. 2.7.1 is the specific version that gnutls 3.1 requires
wget ftp://ftp.gnu.org/gnu/nettle/nettle-2.7.1.tar.gz
tar -xzf nettle-2.7.1.tar.gz
cd nettle-2.7.1
./configure
make
make check
sudo make install
cd -

# gnutls ..  3.1 is current stable
wget ftp://ftp.gnutls.org/gcrypt/gnutls/stable/gnutls-3.1.28.tar.xz
unxz gnutls-3.1.28.tar.xz
tar -xvf gnutls-3.1.28.tar
cd gnutls-3.1.28
./configure
make
make check
sudo make install
cd -

