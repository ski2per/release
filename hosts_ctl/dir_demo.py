import os
import os.path
import paramiko


transport = paramiko.transport.Transport(("192.168.86.86", 22))

transport.connect(username="root", password="hello")
print(transport.get_username())
print(transport.getpeername())


# sftp = paramiko.SFTPClient.from_transport(transport)
sftp = transport.open_sftp_client()
print(sftp)

sftp.put("/Users/Ted/PycharmProjects/release/hosts_ctl/README", "/tmp/")
