#!/bin/bash

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin"

if [ -x /bin/curlx ];then
    echo "ok"
else
    echo "not ok"
fi

yum -y install openssl-devel lzo-devel pam-devel
