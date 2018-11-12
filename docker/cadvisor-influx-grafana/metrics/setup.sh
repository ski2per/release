#!/bin/bash

# docker-compose version 1.10+
# ============================================================================

# Enable Docker Engine API
loaded=$(systemctl status docker | grep -i 'loaded' | awk -F'(' '{print $2}')
docker_service=${loaded%%;*}
echo $docker_service

if [ -e $docker_service ];then
    sed -i 's#^ExecStart=.*#ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375#' $docker_service
    systemctl daemon-reload && systemctl restart docker
else
    echo "$docker_service missing, pls check"
    exit 2
fi

# Setup cadvisor, influxdb and grafana
docker-compose up -d && echo "Container started..."


# Create influxdb for cadvisor
docker exec `docker ps | grep -i influx | awk '{print $1}'` influx -execute 'CREATE DATABASE cadvisor'
