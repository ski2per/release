###### Author           Skipper.D
###### DESCRIPTION      Transport file(teleport) to or execute
######                  command(summon) on remote hosts on remote
######                  hosts
###### VERSION          v2.0
###### UPDATE           2016/01/15
###### DEV PYTHON VER   2.7.10

import os.path
import paramiko

PINK        = '\033[95m'
BLUE        = '\033[94m'
GREEN       = '\033[92m'
YELLOW      = '\033[93m'
RED         = '\033[91m'
UNDERLINE   = '\033[4m'
ENDC        = '\033[0m'


def summon(login, cmd, echo=1):
    # login         - [ip,port,user,password]
    # cmd           - command to execute on remote host
    # echo          - display info or not

    ip      = login[0]
    port    = login[1]
    usr     = login[2]
    psd     = login[3]

    warpgate = paramiko.SSHClient()
    warpgate.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        warpgate.connect(ip, int(port), usr, psd)
        stdin, stdout, stderr = warpgate.exec_command(cmd)
    except:
        return ip

    if echo:
        print('{0}{1:<15}{2}: Summon Completed'.format(GREEN, ip, ENDC))
    for i in stdout.readlines():
            print(i.rstrip('\n'));
    for i in stderr.readlines():
            print(i.rstrip('\n'));

    warpgate.close()
    return 0

def teleport(login, local_file, remote_path, echo=1):
    # login         - list [ip,port,user,password]
    # local_file    - absolute path of local file
    # remote_path   - remote path to store local file
    # echo          - info switch

    # local file is directory, use "os.path.walk()" to scan
    if os.path.isdir(local_file):
        local_base_path = os.path.dirname(local_file)
        remote_path = os.path.abspath(remote_path)
        os.path.walk(local_file, _scan, [login, local_base_path, remote_path, echo])

    # local file is plain file, use "_wormhole()" to transport
    else:
        _wormhole(login, local_file, remote_path, echo)
        


def _scan(arg, dirname, files):
    # arg       - [login, local_base_path, remote_path, echo]
    # dirname   - current directory name
    # files     - file list in "dirname"

    login = arg[0]
    LOCAL_BASE_PATH = arg[1] + '/'
    REMOTE_BASE_PATH = arg[2]
    echo = arg[3]

    remote_file = os.path.join(REMOTE_BASE_PATH, dirname.replace(LOCAL_BASE_PATH, ""))
    remote_path = os.path.dirname(remote_file)

    if _wormhole(login, dirname, remote_path, echo):
        print('{0}{1:<15}{2}: {3:<16} - {4}'.format(YELLOW, login[0], ENDC, "Dir Exists", dirname))
        pass

    for f in files:
        local_file = os.path.join(dirname, f)
        if os.path.isdir(local_file):
            continue
        remote_path = os.path.join(REMOTE_BASE_PATH, dirname.replace(LOCAL_BASE_PATH, ""))
        if _wormhole(login, local_file, remote_path, echo):
            print('{0}{1:<15}{2}: {3:<16} - {4}'.format(FAIL, login[0], ENDC, "Upload Failed", local_file))
            pass


def _wormhole(login, local_file, remote_path, echo):
    # login         - list [ip,port,user,password]
    # local_file    - absolute path of local file
    # remote_path   - remote path to store local file
    # echo          - echo info or not

    ip      = login[0]
    port    = login[1]
    usr     = login[2]
    psd     = login[3]
    
    LOCAL_FILE_NAME = os.path.basename(local_file)
    REMOTE_PATH = os.path.abspath(remote_path)
    REMOTE_FILE = os.path.join(REMOTE_PATH, LOCAL_FILE_NAME)

    try:
        transporter = paramiko.Transport((ip, int(port)))
        transporter.connect(username=usr, password=psd)
    except:
        return ip
    
    warpgate = paramiko.SFTPClient.from_transport(transporter)
    ### upload dir
    if os.path.isdir(local_file):
        try:
            warpgate.mkdir(REMOTE_FILE)
        except:
            return ip
    ### upload file
    else:
        try:
            warpgate.put(local_file, REMOTE_FILE)
        except:
            return ip

    if echo:
        print('{0}{1:<15}{2}: {3:<16} - {4}'.format(GREEN, ip, ENDC, "Upload Completed", REMOTE_FILE))

    # clean up
    warpgate.close()
    transporter.close()
    
    return 0

