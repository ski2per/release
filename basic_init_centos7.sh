#!/bin/bash

###### FARMER        Ted
###### DESCRIPTION   Basic init script for centos 7
###### VERSION       v1.0
###### UPDATE        2018/03/02

HOSTNAME="jenkins"
DISABLE_FW="yes"

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin"

###### Bring up network(DHCP) ######

NIC_NAME=$(grep ':' /proc/net/dev | grep -v 'lo')
NIC_NAME=${NIC_NAME%%:*}
# trim space
#NIC_NAME=$(echo $NIC_NAME | tr -d [:space:])
#NIC_NAME=$(echo $NIC_NAME | sed 's/ //g')
NIC_NAME=${NIC_NAME// /}

NIC_CONF="/etc/sysconfig/network-scripts/ifcfg-"$NIC_NAME

sed -i 's/ONBOOT=no/ONBOOT=yes/' $NIC_CONF
echo "Restart network"
systemctl restart network

###### Install some RPMs ######
echo "Install net-tools sysstat lsof..."
yum -y install net-tools sysstat lsof ntp
systemctl enable ntpd
systemctl start ntpd

###### Turn off SELinux ######
echo "Disable SELinux"
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
setenforce 0

if [[ $DISABLE_FW == "yes" ]];then
    echo "Disable firewall"
    systemctl stop firewalld
    systemctl disable firewalld
fi

###### Set hostname ######
hostnamectl set-hostname $HOSTNAME
