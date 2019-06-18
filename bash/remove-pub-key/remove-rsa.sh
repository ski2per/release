#!/bin/bash

###### CREATOR          Ted       
###### DESCRIPTION      Remove id_rsa.pub in authorized_keys of remote hosts
###### VERSION          v1.1
###### UPDATE           2018/07/09

# CentOS7 PATH
PATH=/bin:/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

DEFAULT_USER=root
HOSTS_CONF=hosts2remove
LOCAL_RSA_PUB=~/.ssh/id_rsa.pub
REMOTE_AUTH=/root/.ssh/authorized_keys
REMOTE_AUTH_TMP=/root/.ssh/authorized_keys_tmp

if [ -e $HOSTS_CONF ] && [ -e $LOCAL_RSA_PUB ];then
    HOSTS=$(cat $HOSTS_CONF)
    RSA_PUB=$(cat $LOCAL_RSA_PUB)
    
else
    echo "Hosts config or id_rsa.pub not exists"
    exit 1
fi


for host in $HOSTS;do
    # Get the line number of id_rsa.pub in authorized_keys of remote host
    line_num=$(ssh $DEFAULT_USER@$host "grep -n \"$RSA_PUB\" $REMOTE_AUTH" | awk -F':' '{print $1}')
    
    if [[ $line_num == "" ]];then
        echo "No id_rsa.pub found on $host"
    else
        echo "id_rsa.pub is in line $line_num of $REMOTE_AUTH on $host"
        echo "Remove id_rsa.pub and generate $REMOTE_AUTH_TMP on $host"
        ssh $DEFAULT_USER@$host "grep -v \"$RSA_PUB\" $REMOTE_AUTH > $REMOTE_AUTH_TMP"

        echo "Backup $REMOTE_AUTH of $host"
        ssh $DEFAULT_USER@$host "mv $REMOTE_AUTH ${REMOTE_AUTH}_bak_$(date +'%Y%m%d') && mv $REMOTE_AUTH_TMP $REMOTE_AUTH" 
    fi
done

