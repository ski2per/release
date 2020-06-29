#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
IP_FILE="$DIR/ip.txt"
LOG="$DIR/ddns.log"

OLD_IP=`cat $IP_FILE 2> /dev/null`

function determine_new_ip {
    NEW_IP=`/usr/bin/curl -s http://devops.cetcxl.com/devops/ip`
    if [ -z "${NEW_IP// }" ];then
        NEW_IP=`/usr/bin/getent hosts cetcxl.tpddns.cn | awk '{print $1}'`
    fi
}

function log {
    msg=$1
    /bin/date +"[%Y/%m/%d %H:%M:%S]: $msg" >> $LOG
}

determine_new_ip

if [ "$OLD_IP" != "$NEW_IP" ];then
    log "IP Changed"
    log "Old IP: $OLD_IP"
    log "New IP: $NEW_IP"
    echo $NEW_IP > $IP_FILE

    # Do something after IP changed
    log "Restart netwatch"
    echo "$NEW_IP"
    sed -i -r "s/(FLANNELD_PUBLIC_IP).+/\1=$NEW_IP/" /opt/devops/netswatch/docker-compose.yml
    /usr/bin/docker-compose -p netswatch -f /opt/devops/netswatch/docker-compose.yml up -d
else
    log "IP not changed"
fi
