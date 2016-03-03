import re
#-------------- log data convert
def log2cache(log_data):

    req_per_hour_dict   = {}
    top_ip_dict         = {}
    req_method_dict     = {}
    status_code_dict    = {}
    single_ip_per_hour  = {}
    # Structure of single_ip_per_hour would like:
    # single_ip_per_hour = {
    #        "01": { "192.168.1.1","192.168.1.2",... }
    #        "02": { "192.168.2.1","192.168.2.2",... }
    #        ...
    #
    # }
    global temp_ip
    access_log_dict     = {}

    # Pattern: (IP, timestamp, http method, status code)
    line_pattern = re.compile('(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}).+\[(.*)\]\s"([A-Z]{3,7})\s.+\s(\d\d\d)\s.+')

    with open(log_data,'r') as log:
        for line in log.readlines():


            m = line_pattern.match(line)

            ############# Line match !!!
            if m:
                ip          = m.group(1)
                hour        = m.group(2).split(':')[1]
                req_method  = m.group(3)
                status_code = m.group(4)

                #=================================================================
                #                    Build top access IP dict
                #=================================================================
                if ip in top_ip_dict:
                    top_ip_dict[ip] += 1
                else:
                    top_ip_dict[ip] = 1



                #=================================================================
                #               Build single ip per hour dict
                #=================================================================
                if hour in single_ip_per_hour:
                    if ip in temp_ip:
                        pass
                    else:
                        temp_ip.append(ip)
                else:
                    temp_ip = []
                    single_ip_per_hour[hour] = temp_ip
                    single_ip_per_hour[hour].append(ip)



                #=================================================================
                #                   Build request per hour dict
                #=================================================================
                if hour in req_per_hour_dict:
                    req_per_hour_dict[hour] += 1
                else:
                    req_per_hour_dict[hour] = 1



                #=================================================================
                #                     Build request method dict
                #=================================================================
                if req_method not in ['GET','HEAD','POST','PUT','DELETE','OPTIONS','TRACE','CONNECT']:
                    req_method = 'BAD'
                if req_method in req_method_dict:
                    req_method_dict[req_method] += 1
                else:
                    req_method_dict[req_method] = 1



                #=================================================================
                #                   Build http status code dict
                #=================================================================
                if status_code in status_code_dict:
                    status_code_dict[status_code] += 1
                else:
                    status_code_dict[status_code] = 1


    for k in single_ip_per_hour:
        single_ip_per_hour[k] = len(single_ip_per_hour[k])

    access_log_dict["top_ip"]               = top_ip_dict
    access_log_dict["single_ip_per_hour"]   = single_ip_per_hour
    access_log_dict["req_per_hour"]         = req_per_hour_dict
    access_log_dict["req_method"]           = req_method_dict
    access_log_dict["status_code"]          = status_code_dict

    return access_log_dict

