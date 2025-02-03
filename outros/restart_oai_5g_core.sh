#!/bin/bash

# Work directory path is the current directory
WORK_DIR=$HOME

## Configuration of the packer forwarding
sudo sysctl net.ipv4.conf.all.forwarding=1
sudo iptables -P FORWARD ACCEPT

## Stop and Remove all containers and images
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)

## Remove OpenAirInterface 5G Core if directory exists
if [ -d "$WORK_DIR/core5g" ]; then
  sudo rm -r $WORK_DIR/core5g
fi

## Clone OpenAirInterface 5G Core
cd $WORK_DIR
cp -r oai/core5g/ $WORK_DIR
cd $WORK_DIR/core5g

## Synchronizing the tutorials
sudo ./scripts/syncComponents.sh

## Create the bridge 5GC
#sudo docker network create --driver=bridge --subnet=192.168.70.128/26 -o "com.docker.network.bridge.name"="eth0" nric-net

## Deploy the 5GC
cd $WORK_DIR/core5g/docker-compose
sudo python3 core-network.py --type start-basic --scenario 1

## Deploy local speedtest
sudo docker run --name speedtest -d -e MODE=standalone -e TELEMETRY=true -e ENABLE_ID_OBFUSCATION=false -e PASSWORD="password" -e WEBPORT=80 -p 80:80 -it adolfintel/speedtest
