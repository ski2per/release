#!/bin/bash


CURL_CMD=$(which curl)
WGET_CMD=$(which wget)

NODE_TAR="node-v8.10.0-linux-x64.tar"

BIG_FILE=$(cat bigfile.list)

for tarfile in $BIG_FILE;do
    rm -f ${tarfile##*/}
done

if [ ! -z $CURL_CMD ];then
    for tarfile in $BIG_FILE;do
        $CURL_CMD -O $tarfile
    done
elif [ ! -z $WGET_CMD ];then
    $WGET_CMD --input-file bigfile.list
else
    echo "command curl or wget not found"
    exit 1
fi

if [ -e $NODE_TAR ];then
    tar -xf $NODE_TAR && rm -f $NODE_TAR
fi
