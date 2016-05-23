# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import os.path
import calendar


BASE_PATH = os.path.dirname(os.path.realpath(__file__))
TEMPLATE = os.path.join(BASE_PATH, 'time.txt')


cal = calendar.Calendar()

with open(TEMPLATE, 'w') as f:
    year = 2015
    for month in range(11, 13):
        for c in cal.itermonthdates(year, month):
            date = c.strftime('%Y-%m-%d')
            line = "%s 09:00\n" % date
            f.write(line)

    year = 2016
    for month in range(1, 6):
        for c in cal.itermonthdates(year, month):
            date = c.strftime('%Y-%m-%d')
            line = "%s 09:00\n" % date
            f.write(line)



