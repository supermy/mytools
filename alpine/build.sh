#!/usr/bin/env bash

docker build -t supermy/alpine base
docker build -t supermy/alpine:build base/build

docker build --build-arg RESTY_J=4  -t supermy/ap-openresty openresty
docker build -t supermy/ap-redis redis
docker build -t supermy/ap-mysql mysql

docker build -t supermy/ap-jre  jre
docker build -t supermy/ap-tomcat  tomcat
docker build -t supermy/ap-tomcat-cluster  tomcat/cluster

docker build -t supermy/ap-rabbitmq  rabbitmq

docker build -t supermy/ap-waf  openresty/waf

docker build -t supermy/ap-mongodb  mongodb

docker build -t supermy/ap-hadoop  hadoop
docker build -t supermy/ap-zk zookeeper
docker build -t supermy/ap-kafka kafka
docker build -t supermy/ap-flume flume

docker build -t supermy/ap-es elasticsearch
docker build -t supermy/ap-nodejs nodejs
-------------------------------------------
docker build -t supermy/ap-jdk jdk
docker build -t supermy/ap-zabbix zabbix
docker build -t supermy/ap-zabbix-agent zabbix/agent
docker build -t supermy/ap-mvn maven
docker build --build-arg JENKINS_VERSION=2.9 -t supermy/ap-jenkins jenkins


