docker build -t jamesmo/debian:7 mydebian
docker build -t jamesmo/jre:7 myjre7
docker build -t jamesmo/jdk:7 myjava7
docker build -t jamesmo/solr:4.10.2 mysolr

docker build -t jamesmo/kafka:0.8 mykafka

docker build -t jamesmo/rabbitmq_base:3.5 myrabbitmq
docker build -t jamesmo/rabbitmq:3.5 myrabbitmq/rabbitmq

docker build -t jamesmo/myflume:latest myflume

docker build -t jamesmo/myredis:3.5 myredis
docker build -t jamesmo/mysql:latest mysql

docker build -t jamesmo/storm_base:0.9.3 mystorm/storm
docker build -t jamesmo/storm-nimbus:0.9.3 mystorm/storm-nimbus
docker build -t jamesmo/storm-supervisor:0.9.3 mystorm/storm-supervisor
docker build -t jamesmo/storm-ui:0.9.3 mystorm/storm-ui
