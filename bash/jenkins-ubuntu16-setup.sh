#!/usr/bin/env bash

###### CREATOR          Ted       
###### DESCRIPTION      Setup Jenkins on Ubuntu 16.04
###### VERSION          v1.0
###### UPDATE           2018/05/03

# TESTED ON UBUNTU 16.04

JENKINS_DEBIAN_KEY="https://pkg.jenkins.io/debian-stable/jenkins.io.key"
JENKINS_DEBIAN_SOURCE="deb https://pkg.jenkins.io/debian-stable binary/"
# Add Jenkins key
curl -s $JENKINS_DEBIAN_KEY | sudo apt-key add -

# Add Jenkins source
sudo echo $JENKINS_DEBIAN_SOURCE >> /etc/apt/sources.list

# Install Jenkins
sudo apt-get update
sudo apt-get install jenkins
