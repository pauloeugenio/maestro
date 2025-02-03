#!/bin/bash

## Install dependencies
sudo apt-get install ca-certificates -y
sudo apt-get install curl -y
sudo apt-get install gnupg -y
sudo apt-get install lsb-release -y


## Installation Wireshark
sudo add-apt-repository ppa:wireshark-dev/stable -y
sudo apt update -y 
sudo apt install wireshark -y


# Work directory path is the current directory
WORK_DIR=$HOME


## Configuration of the packer forwarding
sudo sysctl net.ipv4.conf.all.forwarding=1
sudo iptables -P FORWARD ACCEPT


## Install docker and docker-compose
sudo rm /etc/apt/sources.list.d/docker.list*
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

## Stop and Remove all containers and images
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)
sudo docker rmi $(sudo docker images -a -q)

## Pulling the images from Docker Hub
sudo docker pull oaisoftwarealliance/oai-amf:v1.5.0
sudo docker pull oaisoftwarealliance/oai-nrf:v1.5.0
sudo docker pull oaisoftwarealliance/oai-smf:v1.5.0
sudo docker pull oaisoftwarealliance/oai-udr:v1.5.0
sudo docker pull oaisoftwarealliance/oai-udm:v1.5.0
sudo docker pull oaisoftwarealliance/oai-ausf:v1.5.0
sudo docker pull oaisoftwarealliance/oai-spgwu-tiny:v1.5.0
sudo docker pull oaisoftwarealliance/trf-gen-cn5g:latest



## Tag Docker Images
sudo docker image tag oaisoftwarealliance/trf-gen-cn5g:latest trf-gen-cn5g:latest
sudo docker image tag oaisoftwarealliance/oai-amf:v1.5.0 oai-amf:v1.5.0
sudo docker image tag oaisoftwarealliance/oai-nrf:v1.5.0 oai-nrf:v1.5.0
sudo docker image tag oaisoftwarealliance/oai-smf:v1.5.0 oai-smf:v1.5.0
sudo docker image tag oaisoftwarealliance/oai-udr:v1.5.0 oai-udr:v1.5.0
sudo docker image tag oaisoftwarealliance/oai-udm:v1.5.0 oai-udm:v1.5.0
sudo docker image tag oaisoftwarealliance/oai-ausf:v1.5.0 oai-ausf:v1.5.0
sudo docker image tag oaisoftwarealliance/oai-spgwu-tiny:v1.5.0 oai-spgwu-tiny:v1.5.0



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

## Docker post-installation
# Enabling current user to run docker commands
sudo usermod -aG docker $USER
