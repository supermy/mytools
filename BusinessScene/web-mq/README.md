WEB+MQ
=========================

curl -i -X POST -H "Content-Type:application/json" -d '{"touser":"oio3NwbS8BVVWltnFr7lAeCf2dIw","msgtype":"text","text":{"content":"<a href='https://www.baidu.com'>这是在做测试，hjl。</a>"}}’  'http://133.160.92.53/wechat/message/send.do?json&publicId=gh_ac6502e35283'

[TOC]

#应用场景
提取日志信息push 到MQ；url 作为route key。

##变更日志
###2016-10-12
*  测试nginx 进行 rabbitmq 5672代理

###2016-09-13
*  初始化项目 

##主要功能
-   log_by_lua_file 调用 rabbitmq-插入日志数据；
-   
###conf/lua.app/lua.d
-   首先建立路由与消息队列，定义绑定的路由（从需要截取的url 中提取关键字）
-   reqcontent.lua 将url 转换为mq 的 route key, 访问的请求数据推送到mq；
###conf/lua.app/third.lua.lib
-   提供需要的第三方lua 库
-   提供resty.http 库，进行非阻塞提交；
-   提供json 库，进行lua to json 数据的转换；
###conf/nginx/http.d
-   nginx 对lua第三方库的环境配置；
###conf/nginx/server.d
-   定义测试路径proxymq，在测试路径中对提交的消息进行捕获；
###conf/test-sync-log.sh
-   在rabbitmq 平台建立测试路由与队列，并且发送测试消息；




##测试
###测试
进入到fig.xml 目录执行以下命令进行测试；

    fig up -d && fig ps
    
    http://127.0.0.1/proxymq/index.html
    
    http://127.0.0.1:15672/#/queues
    http://127.0.0.1:15672/api/
    
    fig stop && fig rm -v --force
    