# Docker容器监控系统
使用cAdvisor, InfluxDB跟Grafana搭建的容器监控系统，可以对容器的CPU，内存等数据进行监控

## 组件
* cAdvisor: 类似一个Client，运行在Docker Host上。采集所有运行容器的各种数据并发送给InfluxDB
* InfluxDB: 存储来自cAdvisor数据的时间序列数据库(TSDB)
* Grafana: 将InfluxDB中的进行可视化展示

# 所需环境
docker 17+
docker-compose 1.17+

# 使用

## 1. 单机部署

### 安装grafana+influx
进入 *grafana-influx* 目录，运行：

`docker-compose up -d`

### 安装cadvisor
在 *cadvisor* 目录中：
* docker-compose.yaml: cadvisor单本部署文件
* docker-compose-global.yaml: cadvisor swarm模式部署文件

单机部署需要配置docker-compose.yml中的*hostname*，然后运行：

`docker-compse up -d`


如果需要开启Docker TCP API，可运行：

`bash setup.sh`

*(该setup.sh脚本会同事开启Docker的API端口，端口默认为2375)*

部署完成之后，通过浏览器来访问Grafana，具体端口参考Grafana的docker-compose文件


## 2. 多机部署(或Swarm模式）

部署方式跟单机部署一样，需要安装Grafana跟InfluxDB，并且在进行监控Docker Host上安装cadvisor，并将cadvisor/docker-compose.yml中的-storage_driver_host修改成对应的InfluxDB对应的IP跟端口

对于swarm模式部署，直接运行:

`docker stack deploy -c docker-compose-global.yaml cadvisor`

也可以修改stack.yaml文件来进行部署
