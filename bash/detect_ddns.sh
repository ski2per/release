#!/bin/bash

OLD_IP=`cat /root/ip.txt 2> /dev/null`
NEW_IP=`/usr/bin/getent hosts cetcxl.tpddns.cn | awk '{print $1}'`

if [ "$OLD_IP" != "$NEW_IP" ];then
    echo "IP changed"
    echo $NEW_IP > /root/ip.txt
    echo "Reload Nginx"
    systemctl reload nginx
else
    echo "IP not changed" 
fi

