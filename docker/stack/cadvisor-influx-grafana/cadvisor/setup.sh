#!/bin/bash

# docker-compose version 1.10+
# ============================================================================

# Enable Docker Engine API
loaded=$(systemctl status docker | grep -i 'oaded:' | awk -F'(' '{print $2}')
docker_service=${loaded%%;*}

echo "Save current running containers..."
running_containers=$(docker ps -q --filter status=running)


if [ -e "$docker_service" ];then
    sed -i 's#^ExecStart=.*#ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375#' $docker_service
    echo "Enable Docker API and restart docker"
    systemctl daemon-reload && systemctl restart docker

    echo "Restore containers"
    for container in $running_containers;do
        docker start $container
    done
else
    echo "Cannot found $docker_service"
    exit 2
fi

COMPOSE_BIN=$(which docker-compose)
# Start Cadvisor
if [ -x "$COMPOSE_BIN" ];then
    docker-compose up -d && echo "Cadvisor started..."
else
    echo "Cannot found docker-compose"
    exit 3
fi

