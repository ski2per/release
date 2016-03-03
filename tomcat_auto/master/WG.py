###### Author           Skipper.D
###### DESCRIPTION      A variant of warpgate.py
###### VERSION          v1.1
###### UPDATE           2016/01/14
###### PYTHON VERSION   2
import sys
import os.path
import re
import paramiko


class Warpgate():

    def __init__(self,login):
        self.login = login

    #+------------------------+
    #| Execute remote command |
    #+------------------------+
    def summon(self,cmd):
        ip      = self.login[0]
        port    = self.login[1]
        usr     = self.login[2]
        psd     = self.login[3]
        
        warpgate = paramiko.SSHClient()
        warpgate.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        try:
            warpgate.connect(ip,int(port),usr,psd)
            stdin,stdout,stderr = warpgate.exec_command(cmd)
        except:
            return ip
            
        for i in stdout.readlines():
            print(i.rstrip('\n'));
        for j in stderr.readlines():
            print(j.rstrip('\n'));
    
        warpgate.close()
        return 0
    
    
    #+--------------------------------------+
    #| Upload files/dirs to remote host     |
    #| telport() -> _scan() -> _wormhole() |
    #+--------------------------------------+
    def teleport(self,file2send,remotePath):
         
        ### dir,take a walk
        if os.path.isdir(file2send):
            localPath = os.path.abspath(file2send)
            basePath = os.path.dirname(localPath)
            remotePath = os.path.abspath(remotePath)
    
            os.path.walk(localPath,self._scan,[basePath,remotePath,self.login])

            return "0"
        ### plain file, teleport directly
        else:
            localFile = os.path.abspath(file2send)
            return self._wormhole(localFile,remotePath)

    
    def _scan(self,arg,dirname,files):
        LOCAL_BASE_PATH = arg[0]+'/'
        REMOTE_BASE_PATH = arg[1]
        login = arg[2] # An array contains login info
    
        # Change "/local/path/abc" to "/remote/path/abc"
        remoteFile = os.path.join(REMOTE_BASE_PATH,dirname.replace(LOCAL_BASE_PATH,""))
        remotePath = os.path.dirname(remoteFile)

        if self._wormhole(dirname,remotePath):
            # output some info about dir upload here if you like
            #print("UPLOAD_DIR_ERR")
            pass
    
        for f in files:
            localFile = os.path.join(dirname,f)
            if os.path.isdir(localFile):
                continue
            remotePath = os.path.join(REMOTE_BASE_PATH,dirname.replace(LOCAL_BASE_PATH,""))
            if self._wormhole(localFile,remotePath):
                # output some info about file upload here if you like
                #print("UPLOAD_FILE_ERR")
                pass


    def _wormhole(self,localFile,remotePath):
        ### localFile - full path of local file
        ### remotePath - absolute path on remote 
        ip      = self.login[0]
        port    = self.login[1]
        usr     = self.login[2]
        psd     = self.login[3]
    
        try:
            trans = paramiko.Transport((ip,int(port)))
            trans.connect(username=usr,password=psd)
        except:
            return ip
        
        warpgate = paramiko.SFTPClient.from_transport(trans)
        # delete trailing '/'
        #remotePath = re.sub('\/$',"",remotePath)
        remotePath = os.path.abspath(remotePath)
        
        filename = os.path.basename(localFile)
        remoteFile = remotePath+'/'+filename
       
        ### upload dir
        if os.path.isdir(localFile):
            try:
                warpgate.mkdir(remoteFile)
            except:
                return ip
        ### upload file
        else:
            try:
               warpgate.put(localFile,remoteFile)
            except:
                return ip

        # output some info here if you like 

        warpgate.close()
        trans.close()
        return 0
    
