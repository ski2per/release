#!/bin/bash

# docker-compose version 1.10+
# ============================================================================

#set -x

# Enable Docker Engine API
loaded=$(systemctl status docker | grep -i 'oaded:' | awk -F'(' '{print $2}')
docker_service=${loaded%%;*}
echo $docker_service

if [ -e "$docker_service" ];then
    grep '0.0.0.0:2375' "$docker_service" &> /dev/null
    if [ "$?" -ne 0 ];then
        sed -i '/^ExecStart=/ s#$# -H tcp://0.0.0.0:2375#' $docker_service

        echo "Save current running containers..."
        running_containers=$(docker ps -q --filter status=running 2> /dev/null)

        echo "Enable Docker API and restart docker"
        systemctl daemon-reload && systemctl restart docker

        echo "Restore containers"
        for container in $running_containers;do
            docker start $container
        done
    fi

else
    echo "Cannot found $docker_service"
    exit 2
fi

# Start Cadvisor
COMPOSE_BIN=$(which docker-compose)
if [ -x "$COMPOSE_BIN" ];then
    # Start Docker service if it's stopped
    docker ps &> /dev/null
    if [ "$?" -ne 0 ];then
        systemctl start docker
    fi
    docker-compose up -d && echo "Cadvisor started..."
else
    echo "Cannot found docker-compose"
    exit 3
fi

