#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
IP_FILE="$DIR/ip.txt"
LOG="$DIR/ddns.log"

OLD_IP=`cat $IP_FILE 2> /dev/null`
NEW_IP=`/usr/bin/getent hosts cetcxl.tpddns.cn | awk '{print $1}'`

function log {
    msg=$1
    /bin/date +"[%Y/%m/%d %H:%M:%S]: $msg" >> $LOG
}


if [ "$OLD_IP" != "$NEW_IP" ];then
    log "IP Changed"
    log "Old IP: $OLD_IP"
    log "New IP: $NEW_IP"
    echo $NEW_IP > $IP_FILE

    # Do something after IP changed
    sed -i -r "s/(FLANNELD_PUBLIC_IP).+/\1=$NEW_IP/" docker-compose.yml
else
    log "IP not changed"
fi
