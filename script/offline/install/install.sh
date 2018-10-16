#!/bin/bash
echo -e "\e[33m   ____   __  __ _ _              _____           _        _ _ \e[0m";
echo -e "\e[33m  / __ \ / _|/ _| (_)            |_   _|         | |      | | |\e[0m";
echo -e "\e[33m | |  | | |_| |_| |_ _ __   ___    | |  _ __  ___| |_ __ _| | |\e[0m";
echo -e "\e[33m | |  | |  _|  _| | | '_ \ / _ \   | | | '_ \/ __| __/ _\` | | |\e[0m";
echo -e "\e[33m | |__| | | | | | | | | | |  __/  _| |_| | | \__ \ || (_| | | |\e[0m";
echo -e "\e[33m  \____/|_| |_| |_|_|_| |_|\___| |_____|_| |_|___/\__\__,_|_|_|\e[0m";
echo -e "\e[33m                                                               \e[0m";

echo -e "\e[31mTested on Ubuntu 16.04 Server and Desktop\e[0m";
sleep 2

set -e

PACKAGES="packages"

#NODEJS="$PACKAGES/node-v8.11.3-linux-x64"
NODEJS="$PACKAGES/node-v8.10.0-linux-x64"

BASIC_DEB="$PACKAGES/debs/basic/*.deb"
DOCKER_DEB="$PACKAGES/debs/docker"
DOCKER_DEB_1="$DOCKER_DEB/libltdl7_2.4.6-0.1_amd64.deb"
DOCKER_DEB_2="$DOCKER_DEB/docker-ce_17.03.3_ce-0_ubuntu-xenial_amd64.deb"
POSTGRESQL_DEB="$PACKAGES/debs/postgresql/*.deb"
PYTHON2_DEB="$PACKAGES/debs/python2"
PYTHON2_DEB_LIST=$(cat "$PYTHON2_DEB/install.list")
PIP_PACKAGES="$PACKAGES/pip/*"


DOCKER_COMPOSE="$PACKAGES/docker-compose"

FABRIC_DOCKER_IMG="$PACKAGES/fabric-1.1.tar"
MYSQL_DOCKER_IMG="$PACKAGES/mysql-5.7.tar"

echo ""
echo ""
echo -e "\e[32m========================================================================\e[0m"
echo -e "\e[32mInstall Docker\e[0m"
echo -e "\e[32m========================================================================\e[0m"

sudo dpkg -i $DOCKER_DEB_1
#if [ $? -ne 0 ];then
#    sudo dpkg -i $DOCKER_DEB_1
#fi

sudo dpkg -i $DOCKER_DEB_2
#if [ $? -ne 0 ];then
#    sudo dpkg -i $DOCKER_DEB_2
#fi
sudo apt-get install -f

echo ""
echo ""
echo -e "\e[32m========================================================================\e[0m"
echo -e "\e[32mSetup OpenSSH Server and Enable root login\e[0m"
echo -e "\e[32m========================================================================\e[0m"

sudo dpkg -i $BASIC_DEB
sudo sed -i "s/PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config
sudo systemctl restart sshd
echo "root:root" | sudo chpasswd
sudo passwd -u root


echo ""
echo ""
echo -e "\e[32m========================================================================\e[0m"
echo -e "\e[32mSetup pip and Install pip Packages\e[0m"
echo -e "\e[32m========================================================================\e[0m"

for deb in $PYTHON2_DEB_LIST;do
    sudo dpkg -i "$PYTHON2_DEB/$deb"
done

sudo pip install $PIP_PACKAGES


echo ""
echo ""
echo -e "\e[32m========================================================================\e[0m"
echo -e "\e[32mSetup NodeJS\e[0m"
echo -e "\e[32m========================================================================\e[0m"
echo "Copying NodeJs, may take a while..."
echo ""

sudo cp -a $NODEJS /usr/local/node
sudo ln -sf /usr/local/node/bin/* /usr/local/bin

node --version
npm --version


echo ""
echo ""
echo -e "\e[32m========================================================================\e[0m"
echo -e "\e[32mInstall PostgreSQL\e[0m"
echo -e "\e[32m========================================================================\e[0m"

sudo dpkg -i $POSTGRESQL_DEB
echo "PostgreSQL Installation: $?"




echo ""
echo ""
echo -e "\e[32m========================================================================\e[0m"
echo -e "\e[32mInstall Docker Compose\e[0m"
echo -e "\e[32m========================================================================\e[0m"

DOCKER_PATH=$(which docker)
echo $DOCKER_PATH

if [ -z $DOCKER_PATH ];then
    DIR='/usr/bin'
else
    DIR=$(dirname $DOCKER_PATH)
fi

sudo cp $DOCKER_COMPOSE $DIR/docker-compose
sudo chmod +x $DIR/docker-compose


sudo usermod -a -G docker $USER
newgrp docker <<EOF
bash post-install.sh
EOF
