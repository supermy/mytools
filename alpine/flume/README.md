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
