# -*- coding: utf-8 -*-
import os
import os.path
import datetime
import xlwt
import xlrd
import subprocess
from xlutils.copy import copy

SCRIPT_PATH = os.path.realpath(__file__)
DIR_PATH = os.path.dirname(SCRIPT_PATH)
TEMPLATE = DIR_PATH+"/template.xls"


#TIME_IN_XLS = datetime.datetime.now().strftime('%Y-%m-%d %H:%M')
with open("time.txt",'r') as f:
    for t in f.readlines():
        TIME_IN_XLS = t.strip()
        tmp = TIME_IN_XLS
        TIME_IN_FILENAME = tmp.split(' ')[0]	
        
        EXCEL = DIR_PATH+"/cd_"+TIME_IN_FILENAME+".xls"
        tempWB = xlrd.open_workbook(TEMPLATE, formatting_info=True)
        newWB = copy(tempWB)
        newWS = newWB.get_sheet(0)
        
        for i in xrange(1, 8):
            newWS.write(i, 2, u'正常')
        newWS.write(12, 1, TIME_IN_XLS)
        newWB.save(EXCEL)
        
        TOUCH_TIME = TIME_IN_XLS.replace(' ','')
        TOUCH_TIME = TOUCH_TIME.replace(':','')
        
        cmd = "/bin/touch -t {0} {1}".format(TOUCH_TIME,EXCEL)
        subprocess.call(cmd,shell=True)

