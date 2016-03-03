#!/usr/bin/env python
###### AUTHOR           Skipper
###### DESCRIPTION      Return network traffics (RX/TX) of all network
######                  interface (Use it with "watch" together)
###### VERSION          v1.4
###### UPDATE           2015/09/15
###### PYTHON VERSION   2,3

import time
import re

def sample():
    traffic = {}
    DEV = "/proc/net/dev"
    net = open(DEV,'r')

    for line in net.readlines():
        line = line.strip('\n')
        #if line.count(':') >= 1:
        if re.search(':',line):
            line = line.strip()
            tmp = line.split(':')
            key = tmp[0]
            tmp = tmp[1].split()
            tmp[0] +","+tmp[8]
            traffic[key] = [tmp[0],tmp[8]]
    net.close()
    return traffic

def formatBandwidth(speed): 
    unit = ""
    ### < 1024 - bps
    ### 1024 - Kbps
    ### 1048576(1024*1024) - Mbps
    ### 1073741824(1024*1024*1024) - Gbps  
    
    if speed >= 1073741824:
        speed = '{:.2f}Gbps'.format(speed/1073741824)
        #speed = '{:.2}'.format(str(speed/1073741824))
        return speed+unit
    elif speed >= 1048576:
        speed = '{:.2f}Mbps'.format(speed/1048576)
        #speed = '{:.2}'.format(str(speed/1048576))
        return speed+unit
    elif speed >= 1024:
        speed = '{:.2f}Kbps'.format(speed/1024)
        #speed = '{:.2}'.format(str(speed/1024))
        return speed+unit
    else:
        unit = "bps"
        return str(speed)+unit


if __name__ == "__main__":
    traffic0 =  sample()
    time.sleep(1)
    traffic1 =  sample()
    
    print('{:<20}{:<20}{:<20}'.format("[NIC]","[RX]","[TX]"))
    print('{:=^60}'.format(""))

    for k in sorted(traffic0.keys()):
        rx = int(traffic1[k][0]) - int(traffic0[k][0])
        rx = formatBandwidth(rx)
        
        tx = int(traffic1[k][1]) - int(traffic0[k][1])
        tx = formatBandwidth(tx)
        print('{:<20}{:<20}{:<20}'.format(k,rx,tx))

