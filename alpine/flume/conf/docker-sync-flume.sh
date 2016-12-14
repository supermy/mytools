#!/usr/bin/env bash
#准备flume 初始化数据
/usr/bin/wrapper

rabbitmqctl  add_vhost statuscheckvhost
rabbitmqctl  add_user heartbeat alive
rabbitmqctl  set_permissions -p statuscheckvhost heartbeat ".*" ".*" ".*"
rabbitmqctl set_user_tags heartbeat management
curl -i -u heartbeat:alive http://127.0.0.1:15672/api/aliveness-test/statuscheckvhost


#### 建立数据同步交换路由
curl -i -u heartbeat:alive -H "content-type:application/json" \
    -XPUT -d'{"type":"topic","durable":true}' \
    http://127.0.0.1:15672/api/exchanges/statuscheckvhost/ex-sync-logs

#### 建立数据A 队列、B队列
curl -i -u heartbeat:alive -H "content-type:application/json" \
  -XPUT -d'{"auto_delete":false,"durable":true,"arguments":{}}' \
  http://127.0.0.1:15672/api/queues/statuscheckvhost/queue-a-log
curl -i -u heartbeat:alive -H "content-type:application/json" \
  -XPUT -d'{"auto_delete":false,"durable":true,"arguments":{}}' \
  http://127.0.0.1:15672/api/queues/statuscheckvhost/queue-b-log

#### 绑定路由与消息队列
curl -i -u heartbeat:alive -H "content-type:application/json" \
  -XPOST -d'{"routing_key":"flume.event","arguments":{}}' \
  http://127.0.0.1:15672/api/bindings/statuscheckvhost/e/ex-sync-logs/q/queue-a-log
curl -i -u heartbeat:alive -H "content-type:application/json" \
  -XPOST -d'{"routing_key":"#","arguments":{}}' \
  http://127.0.0.1:15672/api/bindings/statuscheckvhost/e/ex-sync-logs/q/queue-b-log

#### 生产测试数据
curl -i -u heartbeat:alive -H "content-type:application/json" \
  -XPOST -d'{"properties":{},"routing_key":"a.aa","payload":"172.17.0.1 - - [12/Sep/2016:22:57:28 +0800] \"GET /dbtest/token.jsp HTTP/1.1\" 200 317 \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36\" \"-\"","payload_encoding":"string"}' \
  http://127.0.0.1:15672/api/exchanges/statuscheckvhost/ex-sync-logs/publish

curl -i -u heartbeat:alive -H "content-type:application/json" \
  -XPOST -d'{"properties":{},"routing_key":"b.bb","payload":"172.17.0.8 - - [12/Sep/2016:22:57:28 +0800] \"GET /dbtest/token.jsp HTTP/1.1\" 200 317","payload_encoding":"string"}' \
  http://127.0.0.1:15672/api/exchanges/statuscheckvhost/ex-sync-logs/publish

#### 消费测试数据
curl  -i -u heartbeat:alive -H "content-type:application/json" \
 -XPOST -d'{"count":5,"requeue":true,"encoding":"auto","truncate":50000}' \
 http://127.0.0.1:15672/api/queues/statuscheckvhost/queue-a-log/get
curl  -i -u heartbeat:alive -H "content-type:application/json" \
 -XPOST -d'{"count":5,"requeue":true,"encoding":"auto","truncate":50000}' \
 http://127.0.0.1:15672/api/queues/statuscheckvhost/queue-b-log/get
