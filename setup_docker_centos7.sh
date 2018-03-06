#!/bin/bash

###### CREATOR          Ted       
###### DESCRIPTION      Environment setup
###### VERSION          v1.0
###### UPDATE           2018/02/26

# TESTED ON CENTOS 7.4

# Prerequisites
setenforce 0
systemctl stop firewalld
# Install required packages.
yum -y install yum-utils device-mapper-persistent-data lvm2
# Enable ip forward
sysctl -w net.ipv4.ip_forward=1

# Setup Docker
DOCKER_REPO_URL=https://download.docker.com/linux/centos/docker-ce.repo

# Configure Docker repo
yum-config-manager --add-repo $DOCKER_REPO_URL
# Install Docker
yum -y install docker-ce
systemctl enable docker
systemctl start docker
