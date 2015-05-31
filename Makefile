all: prepare check install check

prepare:
	sudo apt-get install libgmp-dev autogen pkg-config make m4 php5-cli php5-curl build-essential

check:
	whoami
	ls -al /usr/local/lib
	ls -al /usr/lib/x86_64-linux-gnu/libgnutls*
	dpkg -l|grep 7\.22 || echo "None"
	dpkg -l|grep 2\.12 || echo "None"
	echo '<?php phpinfo(); ?>' | php |grep -i ssl
	echo '<?php var_dump(curl_version()); ?>' | php 
	pkg-config --modversion gnutls || echo "pkg-config --modversion gnutls failed"
	ldd /usr/lib/x86_64-linux-gnu/libcurl-gnutls.so.4|grep gnut

install: installNettle installGnutls installCurl

installNettle:
	# nettle .. 2.7.1 is the specific version that gnutls 3.1 requires
	wget ftp://ftp.gnu.org/gnu/nettle/nettle-2.7.1.tar.gz
	tar -xzf nettle-2.7.1.tar.gz
	cd nettle-2.7.1 && ./configure && make && make check && sudo make install

installGnutls:
	# gnutls ..  3.1 is current stable
	wget ftp://ftp.gnutls.org/gcrypt/gnutls/stable/gnutls-3.1.28.tar.xz
	unxz gnutls-3.1.28.tar.xz
	tar -xvf gnutls-3.1.28.tar
	cd gnutls-3.1.28 && ./configure && make && make check && sudo make install

curlDependencies1 = --enable-intl \
	--with-openssl \
	--without-pear \
	--with-gd \
	--with-jpeg-dir=/usr \
	--with-png-dir=/usr \
	--with-freetype-dir=/usr \
	--with-freetype \
	--enable-exif \
	--enable-zip \
	--with-zlib \
	--with-zlib-dir=/usr \
	--with-mcrypt=/usr \
	--with-pdo-sqlite \
	--enable-soap \
	--enable-xmlreader \
	--with-xsl \
	--enable-ftp \
	--with-tidy \
	--with-xmlrpc \
	--enable-sysvsem \
	--enable-sysvshm \
	--enable-sysvmsg \
	--enable-shmop \
	--with-mysql=mysqlnd \
	--with-mysqli=mysqlnd \
	--with-pdo-mysql=mysqlnd \
	--enable-pcntl \
	--with-readline \
	--enable-mbstring \
	--with-curl \
	--with-pgsql \
	--with-pdo-pgsql \
	--with-gettext \
	--enable-sockets \
	--with-bz2 \
	--enable-bcmath \
	--enable-calendar \
	--with-libdir=lib \
	--enable-fpm \
	--enable-maintainer-zts \
	--with-gmp \
	--with-kerberos \
	--with-imap \
	--with-imap-ssl \
	--with-ldap=shared \
	--with-ldap-sasl \
	--enable-dba \
	--with-cdb \
	--with-inifile \
	--with-gnutls=/usr/local/lib

curlDependencies2 = --with-config-file-path=/home/travis/.phpenv/versions/5.5.21/etc \
	--with-config-file-scan-dir=/home/travis/.phpenv/versions/5.5.21/etc/conf.d \
	--prefix=/home/travis/.phpenv/versions/5.5.21 \
	--libexecdir=/home/travis/.phpenv/versions/5.5.21/libexec \
	--with-pear=/home/travis/.phpenv/versions/5.5.21/pear

ifeq (`whoami`,"travis")
	curlDependencies = $(curlDependencies1) $(curlDependencies2)
else
	curlDependencies = $(curlDependencies1)
endif

installCurl:
	# compiling curl
	# Purpose is that library link to libgnutls.so.28
	# and not libgnutls.so.26 as below
	# ubuntu@ip-172-31-16-114:~$ ldd /usr/lib/x86_64-linux-gnu/libcurl-gnutls.so.4|grep gnut
	#  libgnutls.so.26 => /usr/lib/x86_64-linux-gnu/libgnutls.so.26 (0x00007fabdfd4d000)
	sudo ln -s /usr/local/lib/libnettle.so.4 /usr/lib/
	sudo ln -s /usr/local/lib/libgnutls.so.28 /usr/lib/
	wget http://curl.haxx.se/download/curl-7.42.1.tar.gz
	tar -xzf curl-7.42.1.tar.gz
	cd curl-7.42.1 && ./configure $(curlDependencies) && make && make check && sudo make install
	sudo rm /usr/lib/x86_64-linux-gnu/libcurl.so.3
	sudo rm /usr/lib/x86_64-linux-gnu/libcurl.so.4
	sudo ln -s /usr/local/lib/libcurl.so.4 /usr/lib/x86_64-linux-gnu/libcurl.so.3
	sudo ln -s /usr/local/lib/libcurl.so.4.3.0 /usr/lib/x86_64-linux-gnu/libcurl.so.4

