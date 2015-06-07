# gnutls-3.1-travisci
Repository just to get to a successful source compilation of gnutls 3.1.28 

The purpose is that '''var_dump(curl_version())''' in php gives a gnutls version of 3.1.28 on travis-ci workers [![Build Status](https://secure.travis-ci.org/shadiakiki1986/gnutls-3.1-travisci.png)](http://travis-ci.org/shadiakiki1986/gnutls-3.1-travisci)

# saving time
THIS IS STILL WORK IN PROGRESS (UPON COMPLETION mv travis2.yml to .travis.yml)

To avoid having to compile curl each time on travis-ci workers, I compile it on an AWS EC2 instance, make deb packages, upload them to S3, share them as public, and finally just download and install them on travis-ci workers. Here is a set of commands that are helpful
'''
sudo apt-get checkinstall
cd nettle...
make # if already installed, no need
sudo checkinstall # instead of make install http://askubuntu.com/questions/140998/compiling-source-into-a-deb-package/141007#141007
pip install awscli # install aws CLI https://aws.amazon.com/cli/
aws configure # enter credentials in this step
aws s3 cp nettle_2.7.1-1_amd64.deb s3://zboota-server/travis-ci\ debian\ packages/
'''
and then I do the same thing for gnutls and for curl, then go to the web console, make these files public, and check that the links in the Makefile are the same as the public links. I would have made the files public via the CLI, but I didn''t find how to do this
