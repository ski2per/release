#!/bin/bash
###### CREATOR          Ted
###### DESCRIPTION      Control script for LVS/DR
###### VERSION          v1.0
###### UPDATE           2018/03/16

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin"
export PATH

VIP=172.16.200.200

case "$1" in
on)
    # Add VIP on lo interface 
    /sbin/ip addr add "$VIP/32" dev lo
    /sbin/ip route add "$VIP/32" via $VIP dev lo

    # Turn off ARP
    echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
    echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
    systcl -p &> /dev/null
    # sysctl -p >/dev/null 2>&1

    echo "RealServer Started"
    ;;
off)
    /sbin/ip addr del "$VIP/32" dev lo
    /sbin/ip route del "$VIP/32" via $VIP dev lo
    echo "0" >/proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "0" >/proc/sys/net/ipv4/conf/lo/arp_announce
    echo "0" >/proc/sys/net/ipv4/conf/all/arp_ignore
    echo "0" >/proc/sys/net/ipv4/conf/all/arp_announce
    echo "RealServer Stopped"
    ;;
*)
       echo "Usage: $0 {on|off}"
       exit 1
esac

exit 0
