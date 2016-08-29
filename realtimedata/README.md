微云（可快速扩充）
====================

实时数据传输[网络高可用]
---------------------


异地高可用的实时数据采集：kafka 升级到0.9测试ok

> 引入Kafka，并且和日志收集服务器部署在本地机房；

> 每台日志收集服务器上的Flume Agent，通过内网将数据发送至Kafka；

> Kafka的第一个消费者，本地网关机上的Flume，负责从Kafka中消费数据，然后流到北京Hadoop集群；

> Kafka的第二个消费者，异地网关机上的Flume，负责从Kafka中消费数据，然后流到西安Hadoop集群；
异地的Flume通过外网连接本地Kafka，主动拉取数据，如果网络不稳定，那么当前批次拉取失败，最多重新拉一次，
数据不会进Flume channel，更不会流到HDFS上，因此，这种方式在网络不稳定的情况下，不会造成数据缺失或重复；

数据分区负载均衡:
> 这种架构下，Kafka成为了统一的日志数据提供者，至关重要。设置3台Broker节点，每个Topic在创建时候都指定了3个分区，

> 副本数为1(追求最高效率)；数据在进入Kafka分区的时候，使用了Flume的拦截器，从日志中提取用户ID，然后通过HASH取模，

> 将数据流到Kafka相应的分区中。一方面，完成了简单的负载均衡，另一方面，确保相同的用户数据都处于同一个分区中，
为后面实时计算模块的统计提供的便利。

Flume拦截器的使用

> 在整个流程中，有两个地方用到了同一个Flume拦截器（Regex Extractor Interceptor），就是在Flume Source中从消息中提取数据，
并加入到Header，供Sink使用；

> 在数据源LogServer上部署的Flume Source，它从原始日志中提取出用户ID，然后加入到Header中，Flume Sink（Kafka Sink）
再入Kafka之前，从Header中拿出该用户ID，然后通过应用分区规则，将该条消息写入Kafka对应的分区中；

> 部署在异地的Flume Source，它从Kafka中读取消息之后，从消息中抽取出时间字段，并加入到Header中，后面的Flume Sink
（HDFS Sink）通过读取Header中时间，根据消息中的时间，将数据写入HDFS相应的目录和文件中。如果在HDFS Sink中仅仅使用当前时间来
确定HDFS目录和文件名称，这样会造成一小部分数据没有写入到正确的目录和文件中，比如：日志中8点59分59秒的数据可能会被写进HDFS上9点
的目录和文件中，因为原始数据经过Kafka，通过外网传输到异地的Flume，有个几秒的延时，那是很正常的。

> 时间戳拦截器，将当前时间戳（毫秒）加入到events header中，key名字为：timestamp，值为当前时间戳。用的不是很多。比如在使用
HDFS Sink时候，根据events的时间戳生成结果文件，hdfs.path = hdfs://cdh5/tmp/dap/%Y%m%d
hdfs.filePrefix = log_%Y%m%d_%H
会根据时间戳将数据写入相应的文件中。
但可以用其他方式代替（设置useLocalTimeStamp = true）。

> 主机名拦截器。将运行Flume agent的主机名或者IP地址加入到events header中，key名字为：host（也可自定义）。

> 静态拦截器，用于在events header中加入一组静态的key和value。

> Search and Replace Interceptor  该拦截器用于将events中的正则匹配到的内容做相应的替换。
  
> Regex Filtering Interceptor  该拦截器使用正则表达式过滤原始events中的内容。

> Regex Extractor Interceptor  该拦截器使用正则表达式抽取原始events中的内容，并将该内容加入events header中。key/value

  
* Volume只有在下列情况下才能被删除：
* 该容器可以用docker rm －v来删除且没有其它容器连接到该Volume（以及主机目录是也没被指定为Volume）。注意，-v是必不可少的。
* docker run中使用rm参数

### 技术实现流程
> RsyslogAgent 采集数据配置 [详见配置文件rsyslog.conf and rsyslog-ngnx.conf]

> FlumeAgent 接收数据,拦截器提取消息中的 timestamp/key/ip 

> 数据输出到kafka,默认按key-Hash 分区存放数据

> 启动kafka 监控

> 消费数据,观察分区消费数据,确认按分区入库




