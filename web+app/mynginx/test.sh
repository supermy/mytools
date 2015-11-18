#!/usr/bin/env bash
#lua test
curl http://192.168.59.103/hello

#echo test
curl http://192.168.59.103/hello1
curl http://192.168.59.103/hello2
curl http://192.168.59.103/hello3?name=tiger

#认证
curl -v -b "ChannelCode=test;ChannelSecretkey=a8152b13f4ef9daca84cf981eb5a7907"  http://192.168.59.103/api
#取数
curl  http://192.168.59.103/api?one=111
curl  "http://192.168.59.103/api?one=111&one=222"

#鉴权
