#!/bin/bash

###### CREATOR          Ted       
###### DESCRIPTION      Load Docker images from dumped tar file
###### VERSION          v1.0
###### UPDATE           2018/05/18

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [[ -e $1 ]];then
    echo "****** UNPACKING $1 ******"
    tar -xvf $1
    folder=${1/.tar/}
    cd $folder
    echo ""

    echo "****** LOADING IMAGE ******"
    for file in $(ls *.tar)
    do
        echo "Loadig: $file"
        docker load < $file
        echo ""
    done
    echo "Finish loading image"
    docker images
    echo ""

    echo "****** RECOVER TAG ******"
    for line in $(cat list)
    do
        tag=${line%%|*}
        image_id=${line##*|}
        docker tag $image_id $tag
    done
    echo "Tags recovered"
    docker images
    echo ""

    echo "****** CLEAN UP ******"
    cd ..
    rm -rf $folder $1

else
    echo "Usage: $0 docker-dump.tar"
    echo "Cannot find $1, quit"
    exit 2
fi
