2017-07-14

压力测试 flume-redis

    JAVA_OPTS="-Xms2048m -Xmx2048m -Xss256k -Xmn2g -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:-UseGCOverheadLimit"
    export JAVA_OPTS=”-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=5445 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false”  
    -Dflume.monitoring.type=http -Dflume.monitoring.port=34545  

2017-07-05

数据同步

    oracle2rabbitmq 并且将数据格式转换为 json
    rabbitmq2mongodb 数据存储到 mongodb

2017-07-04
    
netcat 捕获数据，存储到 mongo ,支持 json 格式

    The sink supports some headers in dynamic model:
    'db': db name
    'collection' : collection name
    
    默认数据库名 events ;db 可以根据 head 指定 db 名称
    默认集合名称 events ;collection 可以根据 head 指定集合名称；
    数据格式 json;
    
    telnet >{"a":1}
    > db.events.find()
    { "_id" : ObjectId("595b0030e4b074bb69ee49b2"), "a" : 1 }

    
    

2017-07-03

增加数据日期过滤
        
    用户数据增加保留3天谴数据；
    日志数据增加
    

2017-07-01

集群Redis Sink 测试

    3A RedisClusterZSetSink 测试完成   上到生产机；
    Log RedisClusterZrangeByScoreSink 测试完成  依赖3A 跑完数据；
    Source RedisClusterSource 测试 filue-redis2log.conf 完成
    

2017-06-28

性能调优
    
    slowlog get 日志 发现 二次结果置入 redis 占用了大量时间；直接在脚本执行呢？
    更换为脚本直接在 redis 执行；去掉返回数据与写入数据的 IO，查看效率；

2017-06-27

更改 Redis 的存储路径,动态修改；

    127.0.0.1:6379> config set dir /disk01/redisdata/
    127.0.0.1:6379> save
    

2017-06-26
    
升级最新版引擎；效果 verygood

            停止码表引擎；
            更新 jar 包；
            升级 flume-taildir2redis.conf ；更新配置到服务器； 
                    com.supermy.redis.flume.redis.sink.RedisZSetSink
            升级 groovy 脚本文件 filter ;convert;  脚本核查完成
                    /etc/flume/conf/g-netuser-filter.groovy
                    /etc/flume/conf/g-netuser-zset-search-replace.groovy
            测试；
            检查日志
            检查 redis
            *** 新版强劲，动力十足 ；原生的 pipeline 2w line 比原有的 eval 快太多了***
            
开始部署日志加工版本；改用文件通道；丢失数据可找回

            本地测试验证；flume config 配置文件是动态加载的；每次刷新重新加载；
                 检查配置文件；flume-taildir2netlog2redis.conf
                 性能参数调整到2W;
                 清理 redis 数据；
                 开启 redis 监控；
                 运行测试；
                 测试完成；
                 
            升级到服务器：
                更新 jar 包
                更新配置文件
                    flume-taildir2netlog2redis.conf
                    g-netlog-filter.groovy
                    g-netlog-search-replace.groovy
                检查配置文件，更改服务器配置
                开启 redis 监控
                启动服务，并且观察日志
                运行正常 6-26 10：48
                
将队列采集到 HDFS
            
            本地服务测试  redis 的消费
                检测配置文件 flume-redis2log.conf
                修改指定队列；
                检查 redis 队列指定长度；
                启动服务；
                观察日志；有日志输出；
                检查 redis 队列长度，所有队列数据已经被消费
                增加 timestamp 脚本二次进行测试
                flume_1 | 2017-06-26 15:18:18,323 (SinkRunner-PollingRunner-DefaultSinkProcessor) [INFO - org.apache.flume.sink.LoggerSink.process(LoggerSink.java:95)] Event: { headers:{timestamp=1498301603000} body: 34 32 2E 35 38 2E 32 31 32 2E 33 34 7C 32 30 31 42.58.212.34|201 }

             
            本地服务测试  hdfs 的生产  测试 ok  
                 a1.sinks.k1.type = hdfs
                 a1.sinks.k1.channel = c1
                 a1.sinks.k1.hdfs.path = /user/hadoop/my/%y-%m-%d/%H%M/%S
                 a1.sinks.k1.hdfs.filePrefix = netlogact-
                 a1.sinks.k1.hdfs.round = true
                 a1.sinks.k1.hdfs.roundValue = 10
                 a1.sinks.k1.hdfs.roundUnit = minute
                    
                 a1.sinks.k1.hdfs.useLocalTimeStamp = true //使用本地时间戳
                
             生产系统测试
                 内存通道被占满，使用文件通道；
                 
                 
                
                
                -- 备用
                
                a1.channels = c1
                a1.channels.c1.type = memory
                a1.sinks = k1
                a1.sinks.k1.type = hive
                a1.sinks.k1.channel = c1
                a1.sinks.k1.hive.metastore = thrift://127.0.0.1:9083
                a1.sinks.k1.hive.database = logsdb
                a1.sinks.k1.hive.table = weblogs
                a1.sinks.k1.hive.partition = asia,%{country},%y-%m-%d-%H-%M
                a1.sinks.k1.useLocalTimeStamp = false
                a1.sinks.k1.round = true
                a1.sinks.k1.roundValue = 10
                a1.sinks.k1.roundUnit = minute
                a1.sinks.k1.serializer = DELIMITED
                a1.sinks.k1.serializer.delimiter = "\t"
                a1.sinks.k1.serializer.serdeSeparator = '\t'
                a1.sinks.k1.serializer.fieldnames =id,,msg
                
                
                a1.channels = c1
                a1.sinks = k1
                a1.sinks.k1.type = hbase
                a1.sinks.k1.table = foo_table
                a1.sinks.k1.columnFamily = bar_cf
                a1.sinks.k1.serializer = org.apache.flume.sink.hbase.RegexHbaseEventSerializer
                a1.sinks.k1.channel = c1
                
                
                a1.sinks.k1.channel = c1
                a1.sinks.k1.type = org.apache.flume.sink.kafka.KafkaSink
                a1.sinks.k1.kafka.topic = mytopic
                a1.sinks.k1.kafka.bootstrap.servers = localhost:9092
                a1.sinks.k1.kafka.flumeBatchSize = 20
                a1.sinks.k1.kafka.producer.acks = 1
                a1.sinks.k1.kafka.producer.linger.ms = 1
                a1.sinks.ki.kafka.producer.compression.type = snappy
                

优化 todo  增加批次数量到100w,测试看效果。                    
                

            
    

2017-06-24
    主要是完成了日志加工脚本；

测试脚本
    flume-taildir2netlog.conf
    bin/flume-ng agent --conf conf --conf-file conf/flume-taildir2netlog.conf --name a1 -Dflume.root.logger=INFO,console

测试脚本,单个记录手动测试，正确入库 redis
    bin/flume-ng agent --conf conf --conf-file conf/flume-netcat2netlog2redis.conf --name a1 -Dflume.root.logger=INFO,console

测试入到 redis 
    flume-taildir2netlog2redis.conf
    bin/flume-ng agent --conf conf --conf-file conf/flume-taildir2netlog2redis.conf --name a1 -Dflume.root.logger=INFO,console
    
    监控产生的数据队列
    LLEN netlogactlist

测试原生插入 Redis，解决 EVAL 独占问题。
    flume-taildir2redis.conf  g-netuser-zset-search-replace.groovy  g-netuser-filter.groovy
        
脚本
    增加非法 IP 地址过滤；
    
    
     
2017-06-23
    
    

优化 redis-lua 脚本，参数传入数据避免 redis 端的 lua缓存；
    ok  netcat2log.conf 测试拦截器  
    ok  netcat2redis.conf 测试 redis 入库
        配置生成删除语句，在特定的时间，进行数据清理；
        
2017-06-20
    Flume-netcat2redis.conf 调试完成；
    
2017-06-20
    调试 groovy + redis ;
    对信息在加密前与解密后，进行编码与解码
    
2017-01-17
    export JAVA_OPTS="-Xms100m -Xmx2000m -Dcom.sun.management.jmxremote -Dflume.monitoring.type=ganglia -Dflume.monitoring.hosts=192.168.150.140:8650"
    
2017-01-04
    连接器进行数据的加密解密，适用于在互联网上传递数据的安全防护。
    

2017-01-03
    redis-source [flume-redis2log.conf]消费数据的使用的测试数据
    127.0.0.1:6379> LPUSH jplist '{"message":1}'
    127.0.0.1:6379> LPUSH jplist '{"message":2}'
    127.0.0.1:6379> LPUSH jplist '{"message":2,"tags":["xyz"],"type":"abc"}'
    redis-sink [flume-netcat2redis.conf]生产数据
    telnet 44444  //生成数据
    127.0.0.1:6379>  rpop jplist //消费数据

2016-12-13
    flume 同步数据测试；
    本地压力测试ok;本地docker 压力测试ok;
    
2016-10-18
    flume 前端数据处理利器 morphline-gork

    morphline 拦截器 text etl 环境准备完成；
    
    morphline syslog 日志etl
    priority : 164
    timestamp : Feb  4 10:46:14
    hostname : syslog
    program : sshd
    pid : 607
    msg : listening on 0.0.0.0 port 22.
    message : Feb  4 10:46:14 syslog sshd[607]: listening on 0.0.0.0 port 22.
    nc -v 127.0.0.1 44446
    >Feb  4 10:46:14 syslog sshd[607]: listening on 0.0.0.0 port 22.
    
    morphline json etl:
    nc -v 127.0.0.1 44446
    Connection to quickstart.cloudera 41415 port [tcp/*] succeeded!
    {"username": "blue", "color": "green"}
    OK
    {"username": "tom", "color": "red"}
    OK
    
    
2016-10-17
    csv2json 增加正则表达式拦截器；
    
    ################示例################
    文本：2011-0101
    h1,h2,h3,h4
    v1,v2,v3,v4
    正则：(\d{4})-(\d{2})(\d{2})
    (.+),(.+),(.+),(.+)\n(.+),(.+),(.+),(.+)
    替换文档：$1-$2-$3
    { "$1" : "$5", "$2" : "$6", "$3" : "$7", "$4" : "$8" }
    结果：2011-01-01
    { "h1" : "v1", "h2" : "v2", "h3" : "v3", "h4" : "v4" }
    
    a1.sources.r1.custom.query = select id,foo,bar  from testdata where id > $@$ order by id asc
    
    ## source 拦截器
    ###########sql source  csv to json ################
    a1.sources.r1.interceptors = i1
    a1.sources.r1.interceptors.i1.type = search_replace
    a1.sources.r1.interceptors.i1.searchPattern = (.+),(.+),(.+)
    a1.sources.r1.interceptors.i1.replaceString = { "id" : $1, "foo" : $2, "bar" : $3 }
    a1.sources.r1.interceptors.i1.charset = UTF-8
    ###########interceptors################
    ---------------------------------------
    
    但morphline还是不可多得的文本ETL利器，无论你是在采集的时候直接用morphline 做ETL还是在服务端做，flume+morphline加起来带来的灵活性也不输Logstash。
    在线调试：https://grokconstructor.appspot.com/do/match?example=1
    已有gork 库：https://github.com/logstash-plugins/logstash-patterns-core/tree/master/patterns
        
    见配置文件 flume-netcat2morphline2log.conf
    
    接下来启动agent。
    
    然后telnet localhost 9999,输入hello world回车。
    
    在agent的日志文件中就可以看到如下日志信息：
    
    Event: { headers:{message=hello world} body: }
    注意这个message属性是添加到了event的headers当中了。
    
    
2016-10-10
    命令行示例
    bin/flume-ng agent --plugins-path plugins.d --conf conf --conf-file conf/flume-mysql2rabbitmq.conf --name a1 -Dflume.root.logger=INFO,console
    
2016-10-09
    测试flume-mysql2rabbitmq.conf
    rabbitmqctl 跨容器访问不能创建用户；docker-sync-flume.sh不能用；
    mqinit 有问题；
    
    
    测试netcat2rabbitmq进行数据消费，测试 ok。
    fig up -d && sh conf/test-sync-flume.sh
    telnet 127.0.0.1 44446
    http://127.0.0.1:15672/#/queues/statuscheckvhost/aliveness-test
    heartbeat/alive   GetMessages 获取消息；
    
    
2016-09-27
    增加插件测试flume-myql flume-rabbitmq
    fig up -d && sh conf/test-sync-flume.sh
    
    flume/lib 目录废弃，改用plugins.d 目录
    
flume-sql jar plugin jar:flume-ng-sql-source-1.4.3-SNAPSHOT.jar
基于hibernate实现，已可以适配所有的关系型数据库。

  $ mkdir -p $FLUME_HOME/plugins.d/sql-source/lib $FLUME_HOME/plugins.d/sql-source/libext
  $ cp flume-ng-sql-source-0.8.jar $FLUME_HOME/plugins.d/sql-source/lib
  mysql
  $ wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.35.tar.gz
  $ tar xzf mysql-connector-java-5.1.35.tar.gz
  $ cp mysql-connector-java-5.1.35-bin.jar $FLUME_HOME/plugins.d/lib/sql-source/libext
  sql server
  $ tar xzf sqljdbc_4.1.5605.100_enu.tar.gz
  $ cp sqljdbc_4.1/enu/sqljdbc41.jar $FLUME_HOME/plugins.d/lib/sql-source/libext
  
  
  -----------------
  If no custom query is set, SELECT <columns.to.select> FROM <table> will be executed each run.query.delay milliseconds configured
  -----------------
  agent.sources.sql-source.custom.query = SELECT incrementalField,field2 FROM table1 WHERE incrementalField > $@$ 
  -----------------
  
  
  # For each one of the sources, the type is defined
  agent.sources.sqlSource.type = org.keedio.flume.source.SQLSource
  
  agent.sources.sqlSource.hibernate.connection.url = jdbc:db2://192.168.56.70:50000/sample
  
  # Hibernate Database connection properties
  agent.sources.sqlSource.hibernate.connection.user = db2inst1
  agent.sources.sqlSource.hibernate.connection.password = db2inst1
  agent.sources.sqlSource.hibernate.connection.autocommit = true
  agent.sources.sqlSource.hibernate.dialect = org.hibernate.dialect.DB2Dialect
  agent.sources.sqlSource.hibernate.connection.driver_class = com.ibm.db2.jcc.DB2Driver
  
  #agent.sources.sqlSource.table = employee1
  
  # Columns to import to kafka (default * import entire row)
  #agent.sources.sqlSource.columns.to.select = *
  
  # Query delay, each configured milisecond the query will be sent
  agent.sources.sqlSource.run.query.delay=10000
  
  # Status file is used to save last readed row
  agent.sources.sqlSource.status.file.path = /var/log/flume
  agent.sources.sqlSource.status.file.name = sqlSource.status
  
  # Custom query
  agent.sources.sqlSource.start.from = 19700101000000000000
  agent.sources.sqlSource.custom.query = SELECT * FROM (select DECIMAL(test) * 1000000 AS INCREMENTAL, EMPLOYEE1.* from employee1 UNION select DECIMAL(test) * 1000000 AS INCREMENTAL, EMPLOYEE2.* from employee2) WHERE INCREMENTAL > $@$ ORDER BY INCREMENTAL ASC
  
  agent.sources.sqlSource.batch.size = 1000
  agent.sources.sqlSource.max.rows = 1000
  
  agent.sources.sqlSource.hibernate.connection.provider_class = org.hibernate.connection.C3P0ConnectionProvider
  agent.sources.sqlSource.hibernate.c3p0.min_size=1
  agent.sources.sqlSource.hibernate.c3p0.max_size=10
  
  # The channel can be defined as follows.
  agent.sources.sqlSource.channels = memoryChannel
  
2016-09-25
flume-rabbitmq plugin jar:rabbitmq-flume-plugin-standalone-1.1.0.jar
### Source

The Source component has the following configuration options:

Variable          | Default       | Description
----------------- | ------------- | -----------
host              | ``localhost`` | The RabbitMQ host to connect to
port              | ``5672``      | The port to connect on
ssl               | ``false``     | Connect to RabbitMQ via SSL
virtual-host      | ``/``         | The virtual host name to connect to
username          | ``guest``     | The username to connect as
password          | ``guest``     | The password to use when connecting
queue             |               | **Required** field specifying the name of the queue to consume from
auto-ack          | ``false``     | Enable auto-acknowledgement for higher throughput with the chance of message loss
requeuing         | ``false``     | Instruct the broker to discard or requeue failed (rejected) messages
prefetchCount     | ``0``         | The ``Basic.QoS`` prefetch count to specify for consuming
timeout           | ``-1``        | The timeout the consumer will wait for rabbitmq to deliver a message before retrying
threads           | ``1``         | The number of consumer threads to create

#### Possible event header keys

- exchange
- routing-key
- app-id
- content-encoding
- content-type
- correlation-id
- delivery-mode
- expires
- message-id
- priority
- reply-to
- timestamp
- type
- user-id

#### Example

```
a1.sources.r1.channels = c1
a1.sources.r1.type = com.aweber.flume.source.rabbitmq.RabbitMQSource
a1.sources.r1.host = localhost
a1.sources.r1.port = 5672
a1.sources.r1.virtual-host = /
a1.sources.r1.username = flume
a1.sources.r1.password = rabbitmq
a1.sources.r1.queue = events_for_s3
a1.sources.r1.prefetchCount = 10
```

### Sink
The RabbitMQ Sink allows for Flume events to be published to RabbitMQ.

Variable           | Default       | Description
------------------ | ------------- | -----------
host               | ``localhost`` | The RabbitMQ host to connect to
port               | ``5672``      | The port to connect on
ssl                | ``false``     | Connect to RabbitMQ via SSL
virtual-host       | ``/``         | The virtual host name to connect to
username           | ``guest``     | The username to connect as
password           | ``guest``     | The password to use when connecting
exchange           | ``amq.topic`` | The exchange to publish the message to
routing-key        |               | The routing key to use when publishing
auto-properties    | ``true``      | Automatically populate AMQP message properties
mandatory-publish  | ``false``     | Enable mandatory publishing
publisher-confirms | ``false``     | Enable publisher confirmations

#### Headers
When publishing an event message, the RabbitMQ Sink will first look to the event
headers for a ``routing-key`` entry. If it is set, it will use that value when
publishing the message. If it is not set, it will fall back to the configured
routing-key value which defaults to an empty string.

If the ``auto-properties`` configuration option is enabled (default), the event
headers will be examined for standard AMQP Basic.Properties entries (sans the
``headers`` AMQP table). If the property is set in the event headers, it will be set
in the message properties. Additionally, if the ``app-id`` value is not set in the
headers, it will default to ``RabbitMQSink``. If ``timestamp`` is not set in the
headers, it will default to the current system time.

##### Available property keys

- app-id
- content-encoding
- content-type
- correlation-id
- delivery-mode
- expires
- message-id
- priority
- reply-to
- timestamp
- type
- user-id

#### Example

```
a1.sinks.k1.channels = c1
a1.sinks.k1.type = com.aweber.flume.sink.rabbitmq.RabbitMQSink
a1.sinks.k1.host = localhost
a1.sinks.k1.port = 5672
a1.sinks.k1.virtual-host = /
a1.sinks.k1.username = flume
a1.sinks.k1.password = rabbitmq
a1.sinks.k1.exchange = amq.topic
a1.sinks.k1.routing-key = flume.event
a1.sinks.k1.publisher-confirms = true


2016-03-22
    flume for alpine ok
    
gosu 启动方式不能正常运行

docker run --name flume-hdfs -e FLUME_AGENT_NAME=agent -d supermy/ap-flume
docker run --name flume-hdfs -e FLUME_AGENT_NAME=agent-v /path/to/conf/dir:/opt/lib/flume/conf -d supermy/ap-flume

Environment variable	Meaning	Default
FLUME_AGENT_NAME	Agent name. Agent specified in the configuration file needs to match this name.	No default (required setting)
FLUME_CONF_DIR	Flume configuration directory. This is where the configuration file is expected to be located.	/opt/lib/flume/conf
FLUME_CONF_FILE	Name of the Flume configuration file.	/opt/lib/flume/conf/flume-conf.properties
