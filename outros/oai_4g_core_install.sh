#!/bin/bash

# Work directory path is the current directory
WORK_DIR=$HOME


## Configuration of the packer forwarding
sudo sysctl net.ipv4.conf.all.forwarding=1
sudo iptables -P FORWARD ACCEPT


## Stop and Remove all containers and images
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)


## Pulling the images from Docker Hub
sudo docker pull cassandra:2.1
sudo docker pull redis:6.0.5
sudo docker pull oaisoftwarealliance/oai-hss:latest
sudo docker pull oaisoftwarealliance/magma-mme:latest
sudo docker pull oaisoftwarealliance/oai-spgwc:latest
sudo docker pull oaisoftwarealliance/oai-spgwu-tiny:latest
sudo docker pull oaisoftwarealliance/oai-enb:develop
sudo docker pull oaisoftwarealliance/oai-lte-ue:develop


## Tag Docker Images
sudo docker image tag oaisoftwarealliance/oai-spgwc:latest oai-spgwc:production
sudo docker image tag oaisoftwarealliance/oai-hss:latest oai-hss:production
sudo docker image tag oaisoftwarealliance/oai-spgwu-tiny:latest oai-spgwu-tiny:production
sudo docker image tag oaisoftwarealliance/magma-mme:latest magma-mme:production


## Clone OpenAirInterface 4G Core
git clone --branch v1.2.0 https://github.com/OPENAIRINTERFACE/openair-epc-fed.git
cd /openair-epc-fed
git checkout -f v1.2.0

## Synchronizing the tutorials
sudo ./openair-epc-fed/scripts/syncComponents.sh


## Initialize the Cassandra DB
cd ./openair-epc-fed/docker-compose/magma-mme-demo
sudo docker-compose up -d db_init & sleep 10
sudo docker logs demo-db-init --follow & sleep 10
sudo docker logs demo-db-init --follow & sleep 10
sudo docker logs demo-db-init --follow & sleep 10
sudo docker rm -f demo-db-init

## Deploy Magma-MME
sudo docker-compose up -d oai_spgwu



## Create the bridge 4GC
sudo docker network create --driver=bridge --subnet=192.168.70.128/26 -o "com.docker.network.bridge.name"="eth0" nric-net


