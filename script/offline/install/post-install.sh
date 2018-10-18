#!/bin/bash

docker version
echo ""
docker-compose version

echo ""
echo ""
echo -e "\e[32m========================================================================\e[0m"
echo -e "\e[32mLoad MySQL Docker Images\e[0m"
echo -e "\e[32m========================================================================\e[0m"
echo "This may take a while, pls wait..."
echo ""
docker load < $MYSQL_DOCKER_IMG

echo ""
echo ""
echo -e "\e[32m========================================================================\e[0m"
echo -e "\e[32mLoad Hyperledger Fabric Docker Images\e[0m"
echo -e "\e[32m========================================================================\e[0m"
echo "This may take a while too, pls wait..."
echo ""
docker load < $FABRIC_DOCKER_IMG

# Retag Hyperledger images to latest
for image in $(docker images | grep hyperledger | awk '{print $1":"$2}');do
    docker tag $image "${image%:*}:latest"
done

docker images

echo -e "\e[33m  _____   ____  _   _ ______ \e[0m";
echo -e "\e[33m |  __ \ / __ \| \ | |  ____|\e[0m";
echo -e "\e[33m | |  | | |  | |  \| | |__   \e[0m";
echo -e "\e[33m | |  | | |  | | . \` |  __|  \e[0m";
echo -e "\e[33m | |__| | |__| | |\  | |____ \e[0m";
echo -e "\e[33m |_____/ \____/|_| \_|______|\e[0m";
echo -e "\e[33m                             \e[0m";
