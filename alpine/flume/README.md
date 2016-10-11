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
