#!/usr/bin/env bash
# 通用工具构造
# 分拆到不同的项目，自动同步到版本库；进行自动镜像构建
cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  base/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/base/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/base/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apBase 初始化项目

cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  base/build/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/build/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/build/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apBuild 初始化项目

cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  jre/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/jre/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/jre/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apJre initProject

#sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/updategit.sh updateCode
#rsync -avz  jdk/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/jdk/

cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  openresty/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/openresty/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/openresty/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apOpenresty 初始化项目
cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  openresty/waf/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/waf/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/waf/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apWaf 初始化项目

cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  tomcat/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/tomcat/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/tomcat/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apTomcat 初始化项目
cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  nodejs/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/nodejs/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/nodejs/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apNodeJs 初始化项目

cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  rabbitmq/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/rabbitmq/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/rabbitmq/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apRabbitMQ 初始化项目

cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  redis/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/redis/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/redis/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apRedis 初始化项目

cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  mysql/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/mysql/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/mysql/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apMysql 初始化项目

cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  hadoop/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/hadoop/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/hadoop/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apHadoop 初始化项目

cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  zookeeper/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/zookeeper/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/zookeeper/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apZK 初始化项目

cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  kafka/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/kafka/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/kafka/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apKafka 初始化项目

cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  mongodb/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/mongodb/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/mongodb/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apMongodb 初始化项目

cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  elasticsearch/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/elasticsearch/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/elasticsearch/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apES 初始化项目

cd /Users/moyong/project/env-myopensource/3-tools/mytools/alpine
rsync -avz  flume/*  /Users/moyong/project/env-myopensource/3-tools/docker/alpines/flume/
cd /Users/moyong/project/env-myopensource/3-tools/docker/alpines/flume/
sh /Users/moyong/project/env-myopensource/3-tools/docker/alpines/addgit.sh apFlume 初始化项目
