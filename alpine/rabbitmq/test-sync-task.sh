#!/usr/bin/env bash
#fig up -d && fig ps

#### 建立数据同步交换路由
curl -i -u guest:guest -H "content-type:application/json" \
    -XPUT -d'{"type":"topic","durable":true}' \
    http://127.0.0.1:15672/api/exchanges/%2f/ex-sync-task

#### 建立数据A 队列、B队列
curl -i -u guest:guest -H "content-type:application/json" \
  -XPUT -d'{"auto_delete":false,"durable":true,"arguments":{}}' \
  http://127.0.0.1:15672/api/queues/%2f/queue-a-task
curl -i -u guest:guest -H "content-type:application/json" \
  -XPUT -d'{"auto_delete":false,"durable":true,"arguments":{}}' \
  http://127.0.0.1:15672/api/queues/%2f/queue-b-table

#### 绑定路由与消息队列
curl -i -u guest:guest -H "content-type:application/json" \
  -XPOST -d'{"routing_key":"#.aa","arguments":{}}' \
  http://127.0.0.1:15672/api/bindings/%2f/e/ex-sync-task/q/queue-a-task
curl -i -u guest:guest -H "content-type:application/json" \
  -XPOST -d'{"routing_key":"#.bb","arguments":{}}' \
  http://127.0.0.1:15672/api/bindings/%2f/e/ex-sync-task/q/queue-b-task

#### 生产测试数据
curl -i -u guest:guest -H "content-type:application/json" \
  -XPOST -d'{"properties":{},"routing_key":"a.aa","payload":"{name:\"张三\",sex:\"男\",age:18}","payload_encoding":"string"}' \
  http://127.0.0.1:15672/api/exchanges/%2f/ex-sync-task/publish

curl -i -u guest:guest -H "content-type:application/json" \
  -XPOST -d'{"properties":{},"routing_key":"b.bb","payload":"{name:\"北京\",code:\"01\"}","payload_encoding":"string"}' \
  http://127.0.0.1:15672/api/exchanges/%2f/ex-sync-task/publish

#### 消费测试数据
curl -XPOST -d'{"count":5,"requeue":true,"encoding":"auto","truncate":50000}' -i -u guest:guest http://127.0.0.1:15672/api/queues/%2f/queue-a-task/get
curl -XPOST -d'{"count":5,"requeue":true,"encoding":"auto","truncate":50000}' -i -u guest:guest http://127.0.0.1:15672/api/queues/%2f/queue-b-task/get
