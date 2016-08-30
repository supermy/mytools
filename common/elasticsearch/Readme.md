2016-07-06
    完成 mysql2es 集群数据的导入；
    channel 数据导入到es 集群中
    
    cd /Users/moyong/project/env-myopensource/3-tools/elasticsearch
    cd /Users/moyong/project/env-myopensource/3-tools/elasticsearch/elasticsearch-jdbc-2.3.3.0-dist
    更新渠道表索引；
    sh bin/mysql-channel.sh
    更新用户表索引；
    sh bin/mysql-users.sh
    
    
2016-07-05
    多数据源->es->es-query->json
    db->es-jdbc->es->es-query->json
    extjs-filter->convert->es-query
    
2016-07-04
    http://192.168.99.101:9200/_plugin/head/
    
    fig up -d && fig ps
    fig rm -v 
    
2016-06-24
    
    docker run -d -v "$PWD/config":/usr/share/elasticsearch/config elasticsearch
    docker run -d elasticsearch elasticsearch -Des.node.name="TestNode"
    http://192.168.99.101:9200/_plugin/head/
    
    集群配置：  ok 
    单节点配置： ok
    
    ik_max_word: 会将文本做最细粒度的拆分，比如会将“中华人民共和国国歌”拆分为“中华人民共和国,中华人民,中华,华人,人民共和国,人民,人,民,共和国,共和,和,国国,国歌”，会穷尽各种可能的组合；
    ik_smart: 会做最粗粒度的拆分，比如会将“中华人民共和国国歌”拆分为“中华人民共和国,国歌”。
   
   Analyzer: `ik_smart` , `ik_max_word` , Tokenizer: `ik_smart` , `ik_max_word` 
   
   Versions
   --------
   
   IK version | ES version
   -----------|-----------
   master | 2.3.1 -> master
   1.9.3 | 2.3.3
   Install
   -------
   
   1.compile
   `mvn package`
   copy and unzip `target/releases/elasticsearch-analysis-ik-{version}.zip` to `your-es-root/plugins/ik`
   
   
   #### Quick Example
   
   1.create a index
   
   ```bash
   curl -XPUT http://192.168.99.101:9200/index
   ```
   
   2.create a mapping
   
   ```bash
   curl -XPOST http://192.168.99.101:9200/index/fulltext/_mapping -d'
   {
       "fulltext": {
                "_all": {
               "analyzer": "ik_max_word",
               "search_analyzer": "ik_max_word",
               "term_vector": "no",
               "store": "false"
           },
           "properties": {
               "content": {
                   "type": "string",
                   "store": "no",
                   "term_vector": "with_positions_offsets",
                   "analyzer": "ik_max_word",
                   "search_analyzer": "ik_max_word",
                   "include_in_all": "true",
                   "boost": 8
               }
           }
       }
   }'
   ```
   
   3.index some docs
   
   ```bash
   curl -XPOST http://192.168.99.101:9200/index/fulltext/1 -d'
   {"content":"美国留给伊拉克的是个烂摊子吗"}
   '
   ```
   
   ```bash
   curl -XPOST http://192.168.99.101:9200/index/fulltext/2 -d'
   {"content":"公安部：各地校车将享最高路权"}
   '
   ```
   
   ```bash
   curl -XPOST http://192.168.99.101:9200/index/fulltext/3 -d'
   {"content":"中韩渔警冲突调查：韩警平均每天扣1艘中国渔船"}
   '
   ```
   
   ```bash
   curl -XPOST http://192.168.99.101:9200/index/fulltext/4 -d'
   {"content":"中国驻洛杉矶领事馆遭亚裔男子枪击 嫌犯已自首"}
   '
   ```
   
   4.query with highlighting
   
   ```bash
   curl -XPOST http://192.168.99.101:9200/index/fulltext/_search  -d'
   {
       "query" : { "term" : { "content" : "中国" }},
       "highlight" : {
           "pre_tags" : ["<tag1>", "<tag2>"],
           "post_tags" : ["</tag1>", "</tag2>"],
           "fields" : {
               "content" : {}
           }
       }
   }
   '
   ```
   
   Result
   
   ```json
   {
       "took": 14,
       "timed_out": false,
       "_shards": {
           "total": 5,
           "successful": 5,
           "failed": 0
       },
       "hits": {
           "total": 2,
           "max_score": 2,
           "hits": [
               {
                   "_index": "index",
                   "_type": "fulltext",
                   "_id": "4",
                   "_score": 2,
                   "_source": {
                       "content": "中国驻洛杉矶领事馆遭亚裔男子枪击 嫌犯已自首"
                   },
                   "highlight": {
                       "content": [
                           "<tag1>中国</tag1>驻洛杉矶领事馆遭亚裔男子枪击 嫌犯已自首 "
                       ]
                   }
               },
               {
                   "_index": "index",
                   "_type": "fulltext",
                   "_id": "3",
                   "_score": 2,
                   "_source": {
                       "content": "中韩渔警冲突调查：韩警平均每天扣1艘中国渔船"
                   },
                   "highlight": {
                       "content": [
                           "均每天扣1艘<tag1>中国</tag1>渔船 "
                       ]
                   }
               }
           ]
       }
   }
   ```
   
   ### Dictionary Configuration
   
   `IKAnalyzer.cfg.xml` can be located at `{conf}/analysis-ik/config/IKAnalyzer.cfg.xml`
   or `{plugins}/elasticsearch-analysis-ik-*/config/IKAnalyzer.cfg.xml`
   
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
   <properties>
   	<comment>IK Analyzer 扩展配置</comment>
   	<!--用户可以在这里配置自己的扩展字典 -->
   	<entry key="ext_dict">custom/mydict.dic;custom/single_word_low_freq.dic</entry>
   	 <!--用户可以在这里配置自己的扩展停止词字典-->
   	<entry key="ext_stopwords">custom/ext_stopword.dic</entry>
    	<!--用户可以在这里配置远程扩展字典 -->
   	<entry key="remote_ext_dict">location</entry>
    	<!--用户可以在这里配置远程扩展停止词字典-->
   	<entry key="remote_ext_stopwords">http://xxx.com/xxx.dic</entry>
   </properties>
   ```
   
   ### 热更新 IK 分词使用方法
   
   目前该插件支持热更新 IK 分词，通过上文在 IK 配置文件中提到的如下配置
   
   ```xml
    	<!--用户可以在这里配置远程扩展字典 -->
   	<entry key="remote_ext_dict">location</entry>
    	<!--用户可以在这里配置远程扩展停止词字典-->
   	<entry key="remote_ext_stopwords">location</entry>
   ```
   
   其中 `location` 是指一个 url，比如 `http://yoursite.com/getCustomDict`，该请求只需满足以下两点即可完成分词热更新。
   
   1. 该 http 请求需要返回两个头部(header)，一个是 `Last-Modified`，一个是 `ETag`，这两者都是字符串类型，只要有一个发生变化，该插件就会去抓取新的分词进而更新词库。
   
   2. 该 http 请求返回的内容格式是一行一个分词，换行符用 `\n` 即可。
   
   满足上面两点要求就可以实现热更新分词了，不需要重启 ES 实例。
   
   可以将需自动更新的热词放在一个 UTF-8 编码的 .txt 文件里，放在 nginx 或其他简易 http server 下，当 .txt 文件修改时，http server 会在客户端请求该文件时自动返回相应的 Last-Modified 和 ETag。可以另外做一个工具来从业务系统提取相关词汇，并更新这个 .txt 文件。
   
   have fun.
   
   常见问题
   -------
   
   1.自定义词典为什么没有生效？
   
   请确保你的扩展词典的文本格式为 UTF8 编码
   

 


2016-02-23
    /Users/moyong/project/env-myopensource/3-tools/elasticsearch-analysis-ik-1.7.0
    

docker run -d elasticsearch

docker run -d supermy/elasticsearch:latest elasticsearch -Des.node.name="TestNode"

docker run -d -v "$PWD/config":/usr/share/elasticsearch/config elasticsearch

docker run -d -v "$PWD/esdata":/usr/share/elasticsearch/data elasticsearch




curl -XPUT http://192.168.99.101:9200/supermy/test/123 -d '{
    "name" : "史密斯"
}'

//索引
$ curl -XPUT http://192.168.99.101:9200/twitter/user/kimchy -d '{
    "name" : "Shay Banon"
}'

//索引，多个field
$ curl -XPUT http://192.168.99.101:9200/twitter/tweet/1 -d '{
    "user": "kimchy",
    "post_date": "2009-11-15T13:12:00",
    "message": "Trying out elasticsearch, so far so good?"
}'

//索引，注意url里面的id是不一样的哦
$ curl -XPUT http://192.168.99.101:9200/twitter/tweet/2 -d '{
    "user": "kimchy",
    "post_date": "2009-11-15T14:12:12",
    "message": "You know, for Search"
}'


//创建索引
curl -XPUT http://192.168.99.101:9200/twitter

//创建Mapping
curl -XPUT http://192.168.99.101:9200/twitter/user/_mapping -d '{
    "properties" : {
        "name" : { "type" : "string" }
    }
}'


//索引
curl -XPUT http://192.168.99.101:9200/twitter/tweet/2 -d '{
    "user": "kimchy",
    "post_date": "2009-11-15T14:12:12",
    "message": "You know, for Search"
}'

//获取
curl -XGET http://192.168.99.101:9200/twitter/tweet/2

-------------
//索引
curl -XPUT http://192.168.99.101:9200/twitter/tweet/2 -d '{
    "user": "kimchy",
    "post_date": "2009-11-15T14:12:12",
    "message": "You know, for Search"
}'

//lucene语法方式的查询
curl -XGET http://192.168.99.101:9200/twitter/tweet/_search?q=user:kimchy

//query DSL方式查询
curl -XGET http://192.168.99.101:9200/twitter/tweet/_search -d '{
    "query" : {
        "term" : { "user": "kimchy" }
    }
}'

//query DSL方式查询
curl -XGET http://192.168.99.101:9200/twitter/_search?pretty=true -d '{
    "query" : {
        "range" : {
            "post_date" : {
                "from" : "2009-11-15T13:00:00",
                "to" : "2009-11-15T14:30:00"
            }
        }
    }
}'

中文分词
https://github.com/supermy/elasticsearch-analysis-ik
http://my.oschina.net/u/579033/blog/394845#OSC_h4_18


http://www.elasticsearch.cn/guide/reference/setup/installation.html
分布式集群
http://my.oschina.net/u/579033/blog/394845
docker exec elasticsearch_fulltext_1  cat /etc/elasticsearch/elasticsearch.yml


http://www.learnes.net/distributed_cluster/README.html

http://tanjianna.diandian.com/post/2013-07-24/elasticsearch-aboutme

ElasticSearch的一些概念:
集群 (cluster)
在一个分布式系统里面,可以通过多个elasticsearch运行实例组成一个集群,这个集群里面有一个节点叫做主节点(master),elasticsearch是去中心化的,所以这里的主节点是动态选举出来的,不存在单点故障。
在同一个子网内，只需要在每个节点上设置相同的集群名,elasticsearch就会自动的把这些集群名相同的节点组成一个集群。节点和节点之间通讯以及节点之间的数据分配和平衡全部由elasticsearch自动管理。
在外部看来elasticsearch就是一个整体。
节点(node)
每一个运行实例称为一个节点,每一个运行实例既可以在同一机器上,也可以在不同的机器上.所谓运行实例,就是一个服务器进程.在测试环境内,可以在一台服务器上运行多个服务器进程,在生产环境建议每台服务器运行一个服务器进程
索引(index)
这里的索引是名词不是动词,在elasticsearch里面支持多个索引。类似于关系数据库里面每一个服务器可以支持多个数据库一样。在每一索引下面又支持多种类型，类似于关系数据库里面的一个数据库可以有多张表。但是本质上和关系数据库有很大的区别。这里暂时可以这么理解
 
分片(shards)
把一个索引分解为多个小的索引，每一个小的索引叫做分片。分片后就可以把各个分片分配到不同的节点中
 
副本(replicas)
每一个分片可以有0到多个副本，每个副本都是分片的完整拷贝，可以用来增加速度，同时也可以提高系统的容错性，一旦某个节点数据损坏，其他节点可以代替他.

curl -XPUT http://127.0.0.1:9200/test
curl -XPOST http://127.0.0.1:9200/test/test/_mapping -d'
{
    "test": {
        "properties": {
            "content": {
                "type" : "string",
                "boost" : 8.0,
                "term_vector" : "with_positions_offsets",
                "analyzer" : "ik",
                "include_in_all" : true
            }
        }
    }
}'
curl 'http://127.0.0.1:9200/test/_analyze?analyzer=ik&pretty=true' -d '
{
"text":"这是我的第一个elasticsearch集群"
}'



新建索引名为test的索引 "curl -XPUT http://192.168.99.101:9200/test"

给索引创建mapping

curl -XPOST http://192.168.99.101:9200/test/test/_mapping -d'
{
    "test": {
        "properties": {
            "content": {
                "type" : "string",
                "boost" : 8.0,
                "term_vector" : "with_positions_offsets",
                "analyzer" : "ik",
                "include_in_all" : true
            }
        }
    }
}'
测试命令
curl 'http://192.168.99.101:9200/test/_analyze?analyzer=ik&pretty=true' -d '
{
"text":"这是我的第一个elasticsearch集群"
}'
测试结果

{
  "tokens" : [ {
    "token" : "text",
    "start_offset" : 4,
    "end_offset" : 8,
    "type" : "ENGLISH",
    "position" : 1
  }, {
    "token" : "这是",
    "start_offset" : 11,
    "end_offset" : 13,
    "type" : "CN_WORD",
    "position" : 2
  }, {
    "token" : "我",
    "start_offset" : 13,
    "end_offset" : 14,
    "type" : "CN_CHAR",
    "position" : 3
  }, {
    "token" : "第一个",
    "start_offset" : 15,
    "end_offset" : 18,
    "type" : "CN_WORD",
    "position" : 4
  }, {
    "token" : "第一",
    "start_offset" : 15,
    "end_offset" : 17,
    "type" : "CN_WORD",
    "position" : 5
  }, {
    "token" : "一个",
    "start_offset" : 16,
    "end_offset" : 18,
    "type" : "CN_WORD",
    "position" : 6
  }, {
    "token" : "一",
    "start_offset" : 16,
    "end_offset" : 17,
    "type" : "TYPE_CNUM",
    "position" : 7
  }, {
    "token" : "个",
    "start_offset" : 17,
    "end_offset" : 18,
    "type" : "COUNT",
    "position" : 8
  }, {
    "token" : "elasticsearch",
    "start_offset" : 18,
    "end_offset" : 31,
    "type" : "ENGLISH",
    "position" : 9
  }, {
    "token" : "集群",
    "start_offset" : 31,
    "end_offset" : 33,
    "type" : "CN_WORD",
    "position" : 10
  } ]
}