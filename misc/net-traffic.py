#!/usr/bin/env python
###### AUTHOR           Ted
###### DESCRIPTION      Return network traffics (RX/TX) of all network
######                  interface (Use it with "watch" command)
###### VERSION          v1.6
###### UPDATE           2019/06/18
###### PYTHON VERSION   2&3

import time


def sample():
    traffic = {}
    with open("/proc/net/dev", "r") as net:

        for line in net.readlines():
            if ":" in line:
                line = line.strip('\n ')
                tmp = line.split(':')
                key = tmp[0]
                tmp = tmp[1].split()
                traffic[key] = [tmp[0], tmp[8]]
    return traffic


def format_bandwidth(speed):
    unit = ""

    # < 1024 - Bps
    # 1024 - KBps
    # 1048576(1024*1024) - MBps
    # 1073741824(1024*1024*1024) - GBps

    if speed >= 1073741824:
        speed = '{:.2f}GBps'.format(speed / 1073741824)
        # speed = '{:.2}'.format(str(speed/1073741824))
        return speed + unit
    elif speed >= 1048576:
        speed = '{:.2f}MBps'.format(speed / 1048576)
        # speed = '{:.2}'.format(str(speed/1048576))
        return speed + unit
    elif speed >= 1024:
        speed = '{:.2f}KBps'.format(speed / 1024)
        # speed = '{:.2}'.format(str(speed/1024))
        return speed + unit
    else:
        unit = "Bps"
        return str(speed) + unit


if __name__ == "__main__":
    traffic0 = sample()
    time.sleep(1)
    traffic1 = sample()

    print('{:>20}{:>20}{:>20}'.format("NIC", "RX", "TX"))
    print('{:-^60}'.format(""))

    for k in sorted(traffic0.keys()):
        rx = int(traffic1[k][0]) - int(traffic0[k][0])
        rx = format_bandwidth(rx)

        tx = int(traffic1[k][1]) - int(traffic0[k][1])
        tx = format_bandwidth(tx)
        print('{:>20}{:>20}{:>20}'.format(k, rx, tx))
