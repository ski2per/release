#!/bin/bash

function colorful_echo {
    RED='\E[31m'
    GREEN='\E[32m'
    YELLOW='\E[33m'
    BLUE='\E[34m'
    WHITE='\E[38m'
    END='\033[0m'

    msg=$1
    color=$2
    case $color in
        "red")
            current_color=$RED
            ;;
        "green")
            current_color=$GREEN
            ;;
        "yellow")
            current_color=$YELLOW
            ;;
        "blue")
            current_color=$BLUE
            ;;
        "*")
            current_color=$WHITE
            ;;
    esac

    echo -e "$current_color$msg$END"

}

function echo_banner {
    echo -e "\e[33m   ____   __  __ _ _              _____           _        _ _ \e[0m";
    echo -e "\e[33m  / __ \ / _|/ _| (_)            |_   _|         | |      | | |\e[0m";
    echo -e "\e[33m | |  | | |_| |_| |_ _ __   ___    | |  _ __  ___| |_ __ _| | |\e[0m";
    echo -e "\e[33m | |  | |  _|  _| | | '_ \ / _ \   | | | '_ \/ __| __/ _\` | | |\e[0m";
    echo -e "\e[33m | |__| | | | | | | | | | |  __/  _| |_| | | \__ \ || (_| | | |\e[0m";
    echo -e "\e[33m  \____/|_| |_| |_|_|_| |_|\___| |_____|_| |_|___/\__\__,_|_|_|\e[0m";
    echo -e "\e[33m                                                               \e[0m";
}

function echo_stage {
    stage_msg=$1

    # Output border character
    stage_color="green"
    border_char="="
    num='72'
    border=$(printf "%-${num}s" "${border_char}")

    echo ""
    echo ""
    colorful_echo "${border// /${border_char}}" $stage_color
    colorful_echo "${stage_msg}" $stage_color
    colorful_echo "${border// /${border_char}}" $stage_color
}

function remove_dpkg_lock {
    # Force remove dpkg lock
    DPKG_LOCK="/var/lib/dpkg/lock"
    if [ -e "$DPKG_LOCK" ];then
        rm -f $DPKG_LOCK
    fi
}

# Installation Function

function install_docker_and_compose {
    remove_dpkg_lock

    DOCKER_DEB="$PACKAGES/debs/docker"
    DOCKER_DEB_1="$DOCKER_DEB/libltdl7_2.4.6-0.1_amd64.deb"
    DOCKER_DEB_2="$DOCKER_DEB/docker-ce_17.03.3_ce-0_ubuntu-xenial_amd64.deb"
    DOCKER_COMPOSE="$PACKAGES/docker-compose"

    echo_stage "Install Docker and Docker Compose"
    
    dpkg -i $DOCKER_DEB_1
    
    dpkg -i $DOCKER_DEB_2
    ret=$?
    if [ $ret -ne 0 ];then
        colorful_echo "Configure Docker service failed, restarting..." "yellow"
        systemctl start docker
        docker_status=$(systemctl status docker | grep 'Active' | awk '{print $2}')
        if [ $docker_status == "active" ];then
            colorful_echo "Docker service status:" "yellow"
            colorful_echo "$docker_status" "green"
        else
            colorful_echo "Docker service is not in ACTIVE status, please check after installation"
            sleep 3
        fi
    fi

    # SAVE FOR FUTURE
    #while [ $ret -ne 0 ];do
    #    colorful_echo "Install docker-ce failed, retry..." "red"
    #    apt-get purge -y docker-ce
    #    apt-get autoremove
    #    sleep 2
    #    dpkg -i $DOCKER_DEB_2
    #done

    sleep 3
    # Copy Docker Compose
    DIR=`dirname $(which docker) 2> /dev/null`
    cp $DOCKER_COMPOSE ${DIR:-/usr/bin}/docker-compose
    chmod +x ${DIR:-/usr/bin}/docker-compose
}

function install_ssh_server {
    remove_dpkg_lock

    BASIC_DEB="$PACKAGES/debs/basic/*.deb"

    echo_stage "Setup OpenSSH Server and Enable root login"

    dpkg -i $BASIC_DEB
    sed -i "s/PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config
    systemctl restart sshd

    # Add password for root before unlock root account
    echo "root:root" | chpasswd
    passwd -u root
}

function install_pip_and_packages {
    remove_dpkg_lock

    PYTHON2_DEB="$PACKAGES/debs/python2"
    PYTHON2_DEB_LIST=$(cat "$PYTHON2_DEB/install.list")
    PIP_PACKAGES="$PACKAGES/pip/*"

    echo_stage "Setup pip and Install pip Packages"

    for deb in $PYTHON2_DEB_LIST;do
        dpkg -i "$PYTHON2_DEB/$deb"
    done

    pip install $PIP_PACKAGES
}

function setup_nodejs {
    NODEJS="$PACKAGES/node-v8.10.0-linux-x64"

    echo_stage "Setup NodeJS"
    colorful_echo "Copying NodeJs, may take a while..." "yellow"

    cp -a $NODEJS /usr/local/node
    ln -sf /usr/local/node/bin/* /usr/local/bin

    colorful_echo "Node Version:" "green"
    node --version
    colorful_echo "NPM Version:" "green"
    npm --version
}

function install_postgresql {
    remove_dpkg_lock

    POSTGRESQL_DEB="$PACKAGES/debs/postgresql/*.deb"

    echo_stage "Install PostgreSQL"
    dpkg -i $POSTGRESQL_DEB
}

function main {
    BASE_DIR=$( cd `dirname $0`; pwd -P)
    PACKAGES="$BASE_DIR/packages"


    echo_banner

    # Print test warning
    colorful_echo "Tested on Ubuntu 16.04 Server and Desktop" "red"
    sleep 2


    # Install Docker and Docker Compose
    install_docker_and_compose

    # Install OpenSSH server and allow remote root login
    install_ssh_server

    # Install pip for fabric_deployer
    install_pip_and_packages

    install_postgresql

    setup_nodejs

    # Enter post instal to get docker group
    echo_stage "Post Installation"

    export FABRIC_DOCKER_IMG="$PACKAGES/fabric-1.1.tar"
    export MYSQL_DOCKER_IMG="$PACKAGES/mysql-5.7.tar"
    usermod -a -G docker $USER
    newgrp docker <<EOF
bash post-install.sh
EOF
}

main
