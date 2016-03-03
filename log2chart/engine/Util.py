import json


def file2json(dataFile):
    with open(dataFile,'r') as f:
        jsonObj = json.load(f)
        #______ return json object,it will be used in highcharts _______
        #return json.dumps(tmp)
        return jsonObj



def json2file(cachePath,data,filename):
    path = cachePath+filename
    with open(path,'w') as f:
        json.dump(data,f)



def dict_to_list(data):
    ###### input data looks like:
    ###### {'POST': 1, 'BAD': 4, 'HEAD': 7, 'GET': 8} 
    listData = []

    for i in data.items():
        listData.append(list(i))
    return listData
    ###### return listData looks like:
    ###### [['POST',1], 
    ######  ['BAD',4],
    ######  ['HEAD',7], 
    ######  ['GET',8]]



def dict_to_sorted_list(data,num=0):
    listData = []

    ###### data needs top x
    if num:
        # Python2
        #tmp = sorted(data.iteritems(),key=lambda d:d[1],reverse=True)
        # Python3
        tmp = sorted(data.items(),key=lambda d:d[1],reverse=True)
        topIP = tmp[:num]
        for i in topIP:
            listData.append(list(i))

    ###### data only needs sorted
    else:
        # Python2
        #tmp = sorted(data.iteritems(),key=lambda d:d[0])
        # Python3
        tmp = sorted(data.items(),key=lambda d:d[0])
        ###### the "tmp" data looks like:
        ###### [('POST': 1), ('BAD': 4), ('HEAD': 7), ('GET': 8)] 
        for i in tmp:
            listData.append(list(i))
    return listData



def get_log_analysis(dataPath,aType,filename):
    ###### aType: per_hour, req_method, status_code, top_ip
    cachePath = dataPath + '/cache/'
    fileCachePath = cachePath + filename
    data = file2json(fileCachePath)
    dictData = data[aType]
        
    listData = []
    if aType == 'req_per_hour' or aType == 'single_ip_per_hour':
        listData = dict_to_sorted_list(dictData)
    elif aType == 'top_ip':
        listData = dict_to_sorted_list(dictData,10)
    else:
        listData = dict_to_list(dictData)

    return json.dumps(listData)
    # This data can be used in highchart directly

