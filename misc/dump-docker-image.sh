#!/bin/bash

###### CREATOR          Ted       
###### DESCRIPTION      Dump Docker images for other Docker daemon
###### VERSION          v1.0
###### UPDATE           2018/05/18

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

WORKSPACE=docker-dump
TAG_LIST=list

echo "****** CREATE WORKSPACE ******"
if [[ -d $WORKSPACE ]];then
    rm -rf $WORKSPACE
fi
mkdir $WORKSPACE
cd $WORKSPACE
echo $WORKSPACE
echo ""

echo "****** GENERATE TAG LIST ******" 
docker images | sed '1d' | grep -v 'none' | awk '{print($1":"$2"|"$3)}' >$TAG_LIST 2>/dev/null
echo $TAG_LIST
cat $TAG_LIST
echo ""

echo "****** DUMP DOCKER IMAGES ******"
images=$(docker images | sed '1d' | grep -v 'none' | awk '{print $3}' | uniq)
for image in $images
do
    echo "Saving image: $image"
    docker save -o "$image.tar" $image
done
echo ""

echo "****** PACK IMAGES ******"
cd ..
tar -cvf "$WORKSPACE.tar" $WORKSPACE
if [[ $? -eq 0 ]];then
    echo "Dump success"
    echo "Clean up"
    rm -rf $WORKSPACE
else
    echo "Dump failed, please retry"
    rm -rf $WORKSPACE
fi



