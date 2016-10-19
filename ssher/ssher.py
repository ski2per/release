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
        """
        Execute a command on remote host

        :param command: Command, like "ps -ef"
        :param kwargs: dict type, {
                                    "IP": "192.168.1.1",
                                    "PORT": 22,
                                    "USERNAME": "ted",
                                    "PASSWORD": "hello"
                                }
        :return: None
        """
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

    def send(self, local, remote, **kwargs):
        ip = kwargs["IP"]
        port = int(kwargs["PORT"])
        username = kwargs["USERNAME"]
        password = kwargs["PASSWORD"]

        transport = paramiko.transport.Transport((ip, port))
        try:
            transport.connect(username=username, password=password)
            sftp = paramiko.SFTPClient.from_transport(transport)

            # Check existence of remote
            sftp.stat(remote)

            # local IS A DIRECTORY
            if os.path.isdir(local):
                parent_dir = os.path.dirname(local)
                os.chdir(parent_dir)
                target_dir = os.path.basename(local)

                for dirpath, dirnames, filenames in os.walk(target_dir):
                    remote_dir = os.path.join(remote, dirpath)
                    try:
                        sftp.mkdir(remote_dir)
                        self.__colored_print(ip, msg="success - {}".format(remote_dir))
                    except IOError:
                        self.__colored_print(ip, msg="{} exists".format(remote_dir), msg_type="info")

                    for filename in filenames:
                        local_file = os.path.join(dirpath, filename)
                        remote_file = os.path.join(remote, local_file)
                        sftp.put(local_file, remote_file)
                        self.__colored_print(ip, msg="success - {}".format(remote_file))

            # local IS A PLAIN FILE
            else:
                filename = os.path.basename(local)
                remote_file = os.path.join(remote, filename)
                sftp.put(local, remote_file)
                self.__colored_print(ip, msg="success - {}".format(remote_file))

        except paramiko.SSHException as err:
            print(err)
        except IOError:
            print("remote not exist")

    def __transport(self):
        pass

    @staticmethod
    def __colored_print(ip, msg="success", msg_type="success"):
        pink = '\033[95m'
        blue = '\033[94m'
        green = '\033[92m'
        yellow = '\033[93m'
        red = '\033[91m'
        underline = '\033[4m'
        endc = '\033[0m'

        TPL = "{0}{1:<15}{2}: [ {3} ]"

        if msg_type == "error":
            print(TPL.format(red, ip, endc, msg))
        elif msg_type == "auth":
            print(TPL.format(yellow, ip, endc, msg))
        elif msg_type == "info":
            print(TPL.format(blue, ip, endc, msg))
        else:
            print(TPL.format(green, ip, endc, msg))


if __name__ == "__main__":

    # This data will be read from configuration
    data = [
        {
            "IP": "192.168.86.86",
            "PORT": "22",
            "USERNAME": "root",
            "PASSWORD": "hello"
        },
        {
            "IP": "10.0.0.107",
            "PORT": "22",
            "USERNAME": "root",
            "PASSWORD": "hello"
        },
    ]

    target = "/Users/Ted/PycharmProjects/release/cl1024"
    # Change path to absolute path
    local_abs_path = os.path.abspath(target)
    if os.path.exists(local_abs_path):
        ssh = SSHer()
        # ssh.execute("cat /proc/version", **data[1])
        ssh.send(local_abs_path, "/tmp", **data[0])
    else:
        print("local file does not exit")
