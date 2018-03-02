#!/usr/bin/env python
# -*- coding=utf-8 -*-

import os
import re
import sys
from time import strftime, localtime
from warpgate import teleport, summon



if __name__ == "__main__":
    print "Inspect initializing\n"

    cwd = os.path.dirname(os.path.abspath(__file__))
    conf = os.path.join(cwd, "conf_cq")
    drone = os.path.join(cwd,"drone")
    currentTime = strftime("%Y/%m/%d %H:%M", localtime())
    remotePath = "/tmp"

    try:
        target = open(conf, 'r')
    except IOError:
        print("OPEN CONF ERROR :/")

    for t in target.readlines():
        t = t.strip('\n')
        if re.match('^$', t) or re.match('^#', t):
            continue
        param = t.split('|')

        if len(param) == 5:
            cmd = 'python /tmp/drone'
        else:
            cmd = "python /tmp/drone " + param.pop()


        ip = param[0]
        domain = param[4]
        login = [ip, param[1], param[2], param[3]]

        #print '{0:-^39}{1}'.format("+", "+")
        print '{0:=^40}'.format("")
        print '{0:>18}{1}{2:>18}{3}'.format(ip, " |", domain, " |")
        print '{0:=^40}'.format("")

        if teleport(login, drone, remotePath, 0):
            print "ERROR"
        else:
            summon(login,cmd, 0)
        print "\n\n"
