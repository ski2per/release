#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re  
import sys
import os.path

def line_filter(line):
    STATIC = [".png",".jpg",".css",".js"]
    INTERNAL_IP = ["10.150","10.105"]

    ipPTN           = re.compile('(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})')
    timePTN         = re.compile('\[(.*)\]')
    httpCodePTN     = re.compile('\s(\d\d\d)\s')
    requestPTN      = re.compile('"([A-Z]{3,7})\s')
    requestUrlPTN   = re.compile('"[A-Z]{3,}\s(.*)\sHTTP.*"')     

    ###### extract IP addr
    match = ipPTN.search(line)
    if match:
        ip = match.group(1)
    
    
    ###### extract request file extension
    match = requestUrlPTN.search(line)
    if match:
        url = match.group(1)
        request = url
    else:
        url = ""
        request = "-"
        
    ###### extract http code
    match = httpCodePTN.search(line)
    if match:
        statusCode = match.group(1)



    if statusCode == "200":
        # filter null request
        if request == "-":
            return 0
        
        # filter extensions in STATIC 
        ext = os.path.splitext(url)[1]
        if ext in STATIC:
            return 0
        
        # filter internal IP
        mIP = re.sub(r'(\d{1,3}\.\d{1,3})\.\d{1,3}\.\d{1,3}',r'\1',ip)
        if mIP in INTERNAL_IP:
            return 0

        #This line is wanted :P
        return 1

    else:
        return 0



if __name__ == "__main__":
    if len(sys.argv) != 2:
        print "No log file :/"
        exit(-1)
    
    inputFile = sys.argv[1]
    #outputFile = codecs.open("gif.txt",'w','utf-8')
    outputFile = open(inputFile+".filtered",'w')
    
    with open(inputFile,'r') as f:
        for line in f.readlines():
            if line_filter(line):
                outputFile.write(line)
    outputFile.close()


