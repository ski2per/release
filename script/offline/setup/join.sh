#!/bin/bash

CLI=`docker ps --format "{{.Names}}" | grep cli`

if [[ "$CLI" == 'peer0.org1.example.com-cli' ]];then
    docker exec $CLI bash -c 'peer channel create -o orderer1.example.com:7050 -c composerchannel -f ./channel-artifacts/channel.tx'
    docker exec $CLI bash -c 'peer channel update -o orderer1.example.com:7050 -c composerchannel -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx'
    docker exec $CLI bash -c 'peer channel join -b composerchannel.block'
else
    docker exec $CLI bash -c 'peer channel fetch oldest composerchannel.block -o orderer1.example.com:7050 -c composerchannel'
    docker exec $CLI bash -c 'peer channel update -o orderer1.example.com:7050 -c composerchannel -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx'
    docker exec $CLI bash -c 'peer channel join -b composerchannel.block'
fi
