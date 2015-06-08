install: 
	#composer install
	wget https://s3-us-west-2.amazonaws.com/zboota-server/travis-ci+debian+packages/nettle_2.7.1-1_amd64.deb && sudo dpkg -i nettle_2.7.1-1_amd64.deb
	sudo ldconfig -v
	#cd /usr/lib/x86_64-linux-gnu/ && sudo rm libgnutls* && cd -
	wget https://s3-us-west-2.amazonaws.com/zboota-server/travis-ci+debian+packages/gnutls_3.1.28-1_amd64.deb && sudo dpkg -i gnutls_3.1.28-1_amd64.deb
	cd /usr/lib/x86_64-linux-gnu/ && sudo rm libgnutls-openssl.so.27 libgnutls-openssl.so libgnutlsxx.so libgnutlsxx.so.27 libgnutls-openssl.so.27.0.0 libgnutlsxx.so.27.0.0 && cd - # testing
	sudo ldconfig -v
	sudo apt-get remove libneon27-gnutls
	# instead of the below rm, which removes /usr/lib/x86.../libcurl-gnutls.so.4 (and even if I ln -s to /usr/local/lib/libcurl.so.4, it doesn't really work), 
	# I should figure out how libcurl-gnutls.so.4 gets generated
	# cd /usr/lib/x86_64-linux-gnu/ && sudo rm libcurl* && cd -
	wget https://s3-us-west-2.amazonaws.com/zboota-server/travis-ci+debian+packages/curl_7.42.1-1_amd64.deb && sudo dpkg -i curl_7.42.1-1_amd64.deb
	sudo ldconfig -v

test:
	phpunit tests/

prepare:
	sudo apt-get update
	sudo apt-get install make php5-cli php5-curl
	#curl -sS https://getcomposer.org/installer | php
	#sudo mv composer.phar /usr/local/bin/composer
	wget https://phar.phpunit.de/phpunit.phar
	chmod +x phpunit.phar
	sudo mv phpunit.phar /usr/local/bin/phpunit

prepare-dev:
	sudo apt-get update
	sudo apt-get install libgmp-dev autogen pkg-config m4 build-essential

check:
	whoami
	ls -al /usr/local/lib
	ls -al /usr/lib/x86_64-linux-gnu/libgnutls* || echo "No file libgnutls* in /usr/lib/x86..."
	ls -al /usr/lib/x86_64-linux-gnu/libcurl* || echo "No file libcurl* in /usr/lib/x86..."
	dpkg -l|grep 7\.22 || echo "None"
	dpkg -l|grep 2\.12 || echo "None"
	echo '<?php phpinfo(); ?>' | php |grep -i ssl
	echo '<?php var_dump(curl_version()); ?>' | php 
	pkg-config --modversion gnutls || echo "pkg-config --modversion gnutls failed"
	pkg-config gnutls --libs || echo "pkg-config gnutls error"
	#ldd /usr/lib/x86_64-linux-gnu/libcurl-gnutls.so.4|grep gnut # Not sure what this is for
	(ldd /usr/lib/php5/20090626/curl.so|grep gnutls)|| echo "no package curl.so in /usr/lib/php5" # after installCurl, this should link to libcurl.so...28 instead of 26
	ls $(HOME)
	ldconfig -p|grep curl
	ldconfig -v|grep curl
	ldconfig -p|grep gnutls
	ldconfig -v|grep gnutls

installNettle:
	# nettle .. 2.7.1 is the specific version that gnutls 3.1 requires
	wget ftp://ftp.gnu.org/gnu/nettle/nettle-2.7.1.tar.gz
	tar -xzf nettle-2.7.1.tar.gz
	#cd nettle-2.7.1 && ./configure && make && make check && sudo make install
	sudo ldconfig -v

installGnutls:
	# gnutls ..  3.1 is current stable
	wget ftp://ftp.gnutls.org/gcrypt/gnutls/stable/gnutls-3.1.28.tar.xz
	unxz gnutls-3.1.28.tar.xz
	tar -xvf gnutls-3.1.28.tar
	cd gnutls-3.1.28 && ./configure && make && make check && sudo make install
	#cd /usr/lib/x86_64-linux-gnu/ && sudo rm -f libgnutls*
	sudo ldconfig -v

installCurl:
	# compiling curl
	wget http://curl.haxx.se/download/curl-7.42.1.tar.gz
	tar -xzf curl-7.42.1.tar.gz
	cd curl-7.42.1 && ./configure --with-ssl --without-gnutls && make && ( make check || echo "curl/make check failed" ) && sudo make install
	#cd /usr/lib/x86_64-linux-gnu/ && sudo rm -f libcurl*
	sudo ldconfig -v

installPhp:
	wget http://php.net/get/php-5.6.9.tar.bz2/from/this/mirror
	bunzip php-5.6.9.tar.bz2
	tar -xvf php-5.6.9.tar
	cd php-5.6.9 && ./configure --with-config-file-path=/home/travis/.phpenv/versions/5.5.21/etc --with-config-file-scan-dir=/home/travis/.phpenv/versions/5.5.21/etc/conf.d --prefix=/home/travis/.phpenv/versions/5.5.21 --libexecdir=/home/travis/.phpenv/versions/5.5.21/libexec --enable-intl --with-openssl --without-pear --with-gd --with-jpeg-dir=/usr --with-png-dir=/usr --with-freetype-dir=/usr --with-freetype --enable-exif --enable-zip --with-zlib --with-zlib-dir=/usr --with-mcrypt=/usr --with-pdo-sqlite --enable-soap --enable-xmlreader --with-xsl --enable-ftp --with-tidy --with-xmlrpc --enable-sysvsem --enable-sysvshm --enable-sysvmsg --enable-shmop --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-pcntl --with-readline --enable-mbstring --with-curl --with-pgsql --with-pdo-pgsql --with-gettext --enable-sockets --with-bz2 --enable-bcmath --enable-calendar --with-libdir=lib --enable-fpm --enable-maintainer-zts --with-gmp --with-kerberos --with-imap --with-imap-ssl --with-ldap=shared --with-ldap-sasl --enable-dba --with-cdb --with-inifile --with-pear=/home/travis/.phpenv/versions/5.5.21/pear && make && make check
	sudo ldconfig -v

