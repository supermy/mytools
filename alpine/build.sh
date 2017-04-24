#!/usr/bin/env bash

docker build -t supermy/alpine base --20170406 build
docker build -t supermy/alpine:build base/build --20170406 build
docker build --build-arg RESTY_J=4  -t supermy/ap-openresty openresty   --20170406 build  增加 luarocks install
        --20170424 升级到.1.11.2.3
docker build --build-arg RESTY_J=4  -t supermy/ap-openresty-fat openresty/alpine-fat  --插件版本  废弃

docker build -t supermy/ap-redis redis
docker build -t supermy/ap-mysql mysql

docker build -t supermy/ap-jre  jre
docker build -t supermy/ap-tomcat  tomcat
docker build -t supermy/ap-tomcat-cluster  tomcat/cluster

docker build -t supermy/ap-rabbitmq  rabbitmq

docker build -t supermy/ap-ssl  openresty/ssl    --20170407 build  auto ssl;
docker build -t supermy/ap-waf  openresty/waf    --20170406 build  opm 安装 ；---20170421 add mongo 官方驱动


docker build -t supermy/ap-mongodb  mongodb

docker build -t supermy/ap-hadoop  hadoop
docker build -t supermy/ap-zk zookeeper
docker build -t supermy/ap-kafka kafka
docker build -t supermy/ap-flume flume

docker build -t supermy/ap-es elasticsearch
docker build -t supermy/ap-nodejs nodejs


--------------------------------------------------------------------------------
docker build -t supermy/ap-jdk jdk
docker build -t supermy/ap-zabbix zabbix
docker build -t supermy/ap-zabbix-agent zabbix/agent
docker build -t supermy/ap-mvn maven
docker build --build-arg JENKINS_VERSION=2.19.4 -t supermy/ap-jenkins jenkins

docker build -t supermy/ap-redis-cs -f redis/Dockerfile-cluster  redis

docker build -t supermy/ap-haproxy  haproxy

docker build -t supermy/ap-netdata  netdata

docker build -t supermy/ap-gitlab  gitlab

docker build -t supermy/ap-rocksdb rocksdb  --20170420 基于 supermy/ap-jre  构建，具备 java 环境
docker build -t supermy/ap-leveldb leveldb

docker build -t supermy/ap-lmdb lmdb        --20170420

docker build -t supermy/ap-lua  lua    --20170406 build  lua luarocks5




