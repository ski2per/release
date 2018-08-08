#!/bin/bash

###### CREATOR          Ted       
###### DESCRIPTION      Script to monitor performance of Docker container
###### VERSION          v1.0
###### UPDATE           2018/05/22

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

function send_email() {

read -r -d '' TEMPLATE <<EOF
From: Docker Monitor <docker-monitor@30.com>
To: Ski2per <ski2per@163.com>
Subject: $1 Warning

$2

EOF

echo "$TEMPLATE" | sendmail ski2per@163.com
}

#CPU threshold (percentage)
THRESHOLD_CPU=3
#Memory threshold (percentage)
THRESHOLD_MEM=2

metrics=$(docker stats --no-stream --format '{{.Name}}|{{.CPUPerc}}|{{.MemPerc}}')

for metric in $metrics
do
    OLD_IFS=$IFS
    IFS="|"
    tmp=($metric)
    IFS=$OLD_IFS

    name=${tmp[0]}
    cpu=${tmp[1]%%%*}
    mem=${tmp[2]%%%*}

    # Test CPU threshold
    result=$(awk -v n1=$cpu -v n2=$THRESHOLD_CPU 'BEGIN{print(n1>n2)?"0":"1"}')
    if [ $result -eq 0 ];then
        date_str=$(date +"%Y/%m/%d %H:%M:%S")
        msg="Container($name): CPU exceeds threshold($cpu/$THRESHOLD_CPU)"
        echo "[$date_str] $msg"

        send_email "CPU" "$msg"
    fi

    # Test Memory threshold
    result=$(awk -v n1=$mem -v n2=$THRESHOLD_MEM 'BEGIN{print(n1>n2)?"0":"1"}')
    if [ $result -eq 0 ];then
        date_str=$(date +"%Y/%m/%d %H:%M:%S")
        msg="Container($name): Memory exceeds threshold($mem/$THRESHOLD_MEM)"
        echo "[$date_str] $msg"

        send_email "Memory" "$msg"
    fi
done

