# gnutls-3.1-travisci
Repository just to get to a successful source compilation of gnutls 3.1.28 

The purpose is that `var_dump(curl_version())` in php gives a gnutls version of 3.1.28 on travis-ci workers [![Build Status](https://secure.travis-ci.org/shadiakiki1986/gnutls-3.1-travisci.png)](http://travis-ci.org/shadiakiki1986/gnutls-3.1-travisci). This was spawned off from [here](https://github.com/shadiakiki1986/just-want-to-pass-dynamodb-travisci). Please check there for more details on why I needed this

# Installing
Run the same commands available in the `.travis.yml before_script` tag

## Saving time on compiling
You will notice that the `install` rule in the makefile downloads some deb packages and installs them.
This is simply to avoid having to compile curl each time on travis-ci workers. I compiled it on an AWS EC2 instance, made deb packages, uploaded them to S3, shared them as public, and finally just download and install them on travis-ci workers. Here is a set of commands that I used to generate the packages and upload them

    sudo apt-get checkinstall
    make installNettle
    cd nettle-2.7.1
    sudo checkinstall # instead of make install http://askubuntu.com/questions/140998/compiling-source-into-a-deb-package/141007#141007
    sudo apt-get install python-pip
    sudo pip install awscli # install aws CLI https://aws.amazon.com/cli/
    aws configure # enter credentials in this step
    aws s3 cp nettle_2.7.1-1_amd64.deb s3://zboota-server/travis-ci\ debian\ packages/
    cd ..
    make installGnutls
    cd gnutls-3.1.28
    sudo checkinstall
    aws s3 cp gnutls_3.1.28-1_amd64.deb s3://zboota-server/travis-ci\ debian\ packages/
    cd ..
    make installCurl
    cd curl-7.42.1
    sudo checkinstall
    aws s3 cp curl_7.42.1-1_amd64.deb s3://zboota-server/travis-ci\ debian\ packages/

Finally, I go to the web console, make these files public, and check that the links in the Makefile are the same as the public links. I would have made the files public via the CLI, but I didn''t find how to do this

## Compiling without making packages
To simply compile and install curl to use the latest gnutls (and consequently compile and install the latest gnutls as prerequisite (and consequently compile and install nettle 2.7.1 as prerequisite))

    make prepare-dev
    make check
    make installNettle
    make installGnutls
    make installCurl
    make check


