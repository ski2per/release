#!/bin/bash

if [[ $# -ne 1 ]] || [[ ! -x "/bin/mknod" ]];then
    exit 1
fi

START=0
TOTAL=$1

while [ $START -le $TOTAL ]
do
    if [ -e "/dev/loop$START" ];then
        START=$(($START+1))
        continue
    else
        /bin/mknod -m 0660 /dev/loop$START b 7 $START
        /bin/chown --reference=/dev/loop1 /dev/loop$START
        START=$(($START+1))
    fi
done

exit 0
