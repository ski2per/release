#!/usr/bin/env python


import sys
import os.path
from warpgate import summon, teleport


login = ["192.168.110.130","22","admin","admin"]

#summon(login,"ls -l /",0)


file = os.path.abspath(sys.argv[1])
teleport(login, file, "/tmp",1)


