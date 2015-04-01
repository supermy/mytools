FROM probablyfine/flume:latest

COPY conf /var/tmp/
COPY lib /opt/flume/lib/

#RUN apt-get install netcat telnet -q  -y

RUN ls -hl /opt/flume/lib

RUN ls -hl /var/tmp/


RUN cat /etc/hosts

RUN  echo "192.168.59.103 hbasemasteripc" >> /etc/hosts


EXPOSE 44444