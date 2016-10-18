"""
Author           Ted
DESCRIPTION      Transport file to or execute
                 command on remote hosts on remote
                 hosts
VERSION          v3.0
UPDATE           2016/10/18
DEV PYTHON VER   2.7
"""

import socket
import os.path
import paramiko


class SSHer(object):
    DEFAULT_PORT = 22
    CONNECTION_TIMEOUT = 5

    def __init__(self, echo=1):
        self._ssh = paramiko.SSHClient()
        self._ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        self.echo = echo

    def execute(self, command, **kwargs):
        ip = kwargs["IP"]
        port = int(kwargs["PORT"])
        username = kwargs["USERNAME"]
        password = kwargs["PASSWORD"]

        try:
            self._ssh.connect(ip, port, username, password, timeout=self.CONNECTION_TIMEOUT)
            stdin, stdout, stderr = self._ssh.exec_command(command)

            if self.echo:
                self.__colored_print(ip)

            for line in stdout:
                print(line.rstrip())
            for line in stderr:
                print(line.rstrip())

        except paramiko.SSHException as err:
            self.__colored_print(ip, str(err), msg_type="auth")
        except socket.error as err:
            self.__colored_print(ip, str(err), msg_type="error")

    @staticmethod
    def transport(local, remote, **kwargs):
        ip = kwargs["IP"]
        port = int(kwargs["PORT"])
        username = kwargs["USERNAME"]
        password = kwargs["PASSWORD"]
        print(kwargs)

        transport = paramiko.transport.Transport((ip, port))
        try:
            transport.connect(username=username, password=password)
            print(transport)
            sftp = paramiko.SFTPClient.from_transport(transport)
            print(sftp.get_channel())

            local_path = os.path.abspath(local)
            if os.path.exists(local_path):
                if os.path.isdir(local_path):
                    pass
                else:
                    sftp.put(local_path, remote)
            else:
                print("not exists")

        except paramiko.SSHException as err:
            print("shit")
            print(err)


    @staticmethod
    def __colored_print(ip, msg="SUCCESS", msg_type="success"):
        PINK = '\033[95m'
        BLUE = '\033[94m'
        GREEN = '\033[92m'
        YELLOW = '\033[93m'
        RED = '\033[91m'
        UNDERLINE = '\033[4m'
        ENDC = '\033[0m'

        TPL = "{0}{1:<15}{2}: [ {3} ]"

        if msg_type == "error":
            print(TPL.format(RED, ip, ENDC, msg.upper()))
        elif msg_type == "auth":
            print(TPL.format(YELLOW, ip, ENDC, msg.upper()))
        else:
            print(TPL.format(GREEN, ip, ENDC, msg))


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

    ip = login[0]
    port = login[1]
    usr = login[2]
    psd = login[3]

    LOCAL_FILE_NAME = os.path.basename(local_file)
    REMOTE_PATH = os.path.abspath(remote_path)
    REMOTE_FILE = os.path.join(REMOTE_PATH, LOCAL_FILE_NAME)

    try:
        transport = paramiko.transport.Transport((ip, int(port)))
        transport.connect(username=usr, password=psd)
    except:
        return ip

    warpgate = paramiko.SFTPClient.from_transport(transport)
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


if __name__ == "__main__":

    data = [
        {
            "IP": "192.168.86.86",
            "PORT": "22",
            "USERNAME": "root",
            "PASSWORD": "hello"
        },
        {
            "IP": "19.168.86.86",
            "PORT": "22",
            "USERNAME": "root",
            "PASSWORD": "hello"
        },
    ]

    ssh = SSHer()
    # ssh.execute("echo 'shit'", **data[0])
    ssh.transport("conf", "/tmp", **data[0])
