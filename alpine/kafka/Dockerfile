FROM supermy/ap-jre

MAINTAINER JamesMo <springclick@gmail.com>

#http://apache.fayea.com/kafka/0.10.0.1/kafka_2.11-0.10.0.1.tgz
#http://www-us.apache.org/dist/kafka/0.10.0.1/kafka_2.11-0.10.0.1.tgz

RUN  wget  http://www-us.apache.org/dist/kafka/0.10.0.1/kafka_2.11-0.10.0.1.tgz -O /tmp/kafka_2.11-0.10.0.1.tgz \
    && tar xfz /tmp/kafka_2.11-0.10.0.1.tgz -C /opt  \
    && rm /tmp/kafka_2.11-0.10.0.1.tgz

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_2.11-0.10.0.1

COPY gosu /bin/gosu
ADD shell/start-kafka.sh /usr/bin/start-kafka.sh
ADD shell/broker-list.sh /usr/bin/broker-list.sh
ADD docker-entrypoint.sh /entrypoint.sh


RUN chmod a+x /bin/gosu
RUN chmod a+x /usr/bin/start-kafka.sh
RUN chmod a+x /usr/bin/broker-list.sh
RUN chmod a+x /entrypoint.sh

#RUN apk add tpaste

ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]