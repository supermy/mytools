FROM supermy/docker-jre:7

#FROM probablyfine/flume:latest

RUN mkdir /opt/flume
RUN wget -qO- http://archive.apache.org/dist/flume/1.5.0/apache-flume-1.5.0-bin.tar.gz \
  | tar zxvf - -C /opt/flume --strip 1


COPY conf /var/tmp/
COPY lib /opt/flume/lib/


#RUN ls -hl /opt/flume/lib
#RUN ls -hl /var/tmp/


RUN cat /etc/hosts

RUN  echo "192.168.59.103 hbasemasteripc" >> /etc/hosts


ADD start-flume.sh /opt/flume/bin/start-flume

ENV JAVA_HOME /opt/java
ENV PATH /opt/flume/bin:/opt/java/bin:$PATH

CMD [ "start-flume" ]

EXPOSE 44444