#!/usr/bin/env bash
fig up -d && fig ps
#http://192.168.59.103:15672/#/  guest/guest
java -jar gs-messaging-rabbitmq-0.1.0.jar

curl -i -u guest:guest -H "content-type:application/json" \
    -XPUT -d'{"type":"direct","durable":true}' \
    http://192.168.59.103:15672/api/exchanges/%2f/my-new-exchange

curl -i -u guest:guest -H "content-type:application/json" \
  -XPUT -d'{"auto_delete":false,"durable":true,"arguments":{}}' \
  http://192.168.59.103:15672/api/queues/%2f/test


curl -i -u guest:guest -H "content-type:application/json" \
  -XPOST -d'{"properties":{},"routing_key":"test","payload":"my body","payload_encoding":"string"}' \
  http://192.168.59.103:15672/api/exchanges/%2f/amq.default/publish

curl -XPOST -d'{"count":5,"requeue":true,"encoding":"auto","truncate":50000}' -i -u guest:guest http://192.168.59.103:15672/api/queues/%2f/test/get
