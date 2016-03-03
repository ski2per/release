master login [start|stop|reboot|list] tomcat_home
    login       - 服务器登录参数 ["ip","ssh_port","usr","psd"]
    start       - 启动tomcat_home下的容器
    stop        - 停止tomcat_home下的容器
    reboot      - 重启tomcat_home下的容器
    list        - 返回tomcat_home下的备份文件的绝对路径列表
    tomcat_home - Tomcat容器的主目录
    
    示例：
    ./master '["192.168.110.130","22","root","hello"]' start /opt/tomcat.node00
    python master '["192.168.110.130","22","root","hello"]' list /opt/tomcat.node00

_____________________________________________________________________________________
master login backup tomcat_home app_name
    login       - 服务器登录参数 ["ip","ssh_port","usr","psd"]
    backup      - 备份tomcat_home/webapps下的app_name应用
    tomcat_home - Tomcat容器的主目录
    app_name    - Java应用名
    
    示例：
    ./master '["192.168.110.130","22","root","hello"]' backup /opt/tomcat.node00 wh

_____________________________________________________________________________________
master login restore abs_path_to_backup_file
    login                   - 服务器登录参数 ["ip","ssh_port","usr","psd"]
    restore                 - 从指定备份文件恢复应用 
    abs_path_to_backup_file - 备份文件的远程绝对路径，恢复该文件会将应用恢复到备份前的路径

    示例：
    ./master '["192.168.110.130","22","root","hello"]' restore /opt/tomcat.node00/backup/wh.2015-11-13.13-39.tar.gz

_____________________________________________________________________________________
master login upload file_to_upload remote_path
    login           - 服务器登录参数 ["ip","ssh_port","usr","psd"]
    upload          - 上传本地的文件或目录到remote_path
    fil_to_upload   - 需要上传的文件路径
    remote_path     - 远端存放文件的路径，如，本地文件为/home/abc/file.zip,
                    - 远端路径为/tmp/，则文件会被上传到/tmp/file.zip

    示例：
    # 绝对路径
    ./master '["192.168.110.130","22","root","hello"]' upload /root/code_D/python/tomcat/master/conf/ /tmp
    # 相对路径
    ./master '["192.168.110.130","22","root","hello"]' upload conf/ /tmp
