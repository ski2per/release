#!/usr/bin/env bash

NETNS_DIR="/var/run/netns"
NL='\n'

GREEN='\e[32m'
END='\e[0m'

get_container_veth() {
    # Input: container_name:container_id
    container_name=${1%:*} 
    container_id=${1#*:}

    pid=`docker inspect --format='{{.State.Pid}}' ${container_id}`
    ln -sf "/proc/${pid}/ns/net" "$NETNS_DIR/ns-${pid}"
    veth=`ip netns exec "ns-${pid}" ip link show type veth`
    veth_index=${veth%%:*}
    addrs=`ip link show type veth`
    tmp="${addrs%%@if${veth_index}:*}"
    tmp="${tmp##*${NL}}"
    echo -e "$container_name[$container_id] -> $GREEN${tmp##* }$END"
}

main() {
    # Make sure netns directory exists
    if [[ ! -d $NETNS_DIR ]];then
        mkdir -p $NETNS_DIR
    fi

    for cid in `docker ps --format "{{.Names}}:{{.ID}}"`;do
        get_container_veth $cid
    done
}


main
