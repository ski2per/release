#!/usr/bin/env bash

###### CREATOR          Ted       
###### DESCRIPTION      Setup openvpn client on CentOS
###### VERSION          v1.1
###### UPDATE           2018/08/09

# Download openvpn sourcecode first
SOURCE="openvpn-2.4.6.tar.gz"

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin"

# Install prerequisites
yum -y install gcc openssl-devel lzo-devel pam-devel

tar -zxvf $SOURCE

folder=${SOURCE/.tar.gz/}
cd $folder
./configure
make && make install
cd ..

rm -rf $folder
