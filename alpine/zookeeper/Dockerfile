FROM supermy/ap-jre

MAINTAINER JamesMo

#RUN apk add --update bash curl wget vim htop && rm -rf /var/cache/apk/*

RUN wget -q -O - http://mirror.vorboss.net/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz | tar -xzf - -C /opt  \
    && mv /opt/zookeeper-3.4.6/conf/zoo_sample.cfg /opt/zookeeper-3.4.6/conf/zoo.cfg

ENV JAVA_HOME=/opt/jdk1.7.0_80/jre

ENV ZK_HOME /opt/zookeeper-3.4.6
RUN sed  -i "s|/tmp/zookeeper|$ZK_HOME/data|g" $ZK_HOME/conf/zoo.cfg; mkdir $ZK_HOME/data

EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper-3.4.6
VOLUME ["/opt/zookeeper-3.4.6/conf", "/opt/zookeeper-3.4.6/data"]

ADD start-zk.sh /usr/local/bin/start-zk.sh
RUN chmod +x /usr/local/bin/start-zk.sh
CMD ["/usr/local/bin/start-zk.sh"]