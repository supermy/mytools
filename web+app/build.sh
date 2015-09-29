#!/usr/bin/env bash
docker build -t supermy/docker-mynginx:2.1 mynginx
docker build -t supermy/docker-mytomcat:7 mytomcat

docker build -t supermy/docker-tomcat-redis:7 -f mytomcat/Dockerfile-redis mytomcat

docker build -t supermy/docker-springboot springboot
