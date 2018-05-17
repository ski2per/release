#!/bin/bash

###### CREATOR          Ted       
###### DESCRIPTION      Dump Docker images for other Docker daemon
###### VERSION          v1.0
###### UPDATE           2018/05/18

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

WORKSPACE=docker-dump
IMAGE_TAG_LIST=list

echo "------ CREATE WORKSPACE ------"
if [[ -d $WORKSPACE ]];then
    cd $WORKSPACE
else
    mkdir $WORKSPACE
    cd $WORKSPACE
fi
echo $WORKSPACE

echo "------ GENERATE IMAGE AND TAG LIST ------"
docker images | sed '1d' | awk '{print($1":"$2"|"$3)}' >$IMAGE_TAG 2>/dev/null
echo $IMAGE_TAG_LIST

echo "------ DUMP DOCKER IMAGES ------"

