FROM    myjre7_base

MAINTAINER jamesmo

RUN apt-get update; apt-get install -y unzip wget git

RUN wget -q http://mirror.gopotato.co.uk/apache/kafka/0.8.2.0/kafka_2.11-0.8.2.0.tgz -O /tmp/kafka_2.11-0.8.2.0.tgz
RUN tar xfz /tmp/kafka_2.11-0.8.2.0.tgz -C /opt

RUN rm /tmp/kafka_2.11-0.8.2.0.tgz

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_2.11-0.8.2.0

ADD shell/start-kafka.sh /usr/bin/start-kafka.sh
ADD shell/broker-list.sh /usr/bin/broker-list.sh

CMD start-kafka.sh