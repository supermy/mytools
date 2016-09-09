FROM supermy/ap-jre

MAINTAINER JamesMo <springclick@gmail.com>

ENV TOMCAT_MAJOR=7 \
    TOMCAT_VERSION=7.0.70 \
    TOMCAT_HOME=/opt/tomcat \
    CATALINA_HOME=/opt/tomcat \
    CATALINA_OUT=/dev/null

RUN apk add --update curl && \
    curl -jksSL -o /tmp/apache-tomcat.tar.gz http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    gunzip /tmp/apache-tomcat.tar.gz && \
    tar -C /opt -xf /tmp/apache-tomcat.tar && \
    ln -s /opt/apache-tomcat-${TOMCAT_VERSION} ${TOMCAT_HOME} && \
    apk del curl && \
    rm -rf /tmp/* /var/cache/apk/*

#    rm -rf ${TOMCAT_HOME}/webapps/* && \  方便调测

COPY logging.properties ${TOMCAT_HOME}/conf/logging.properties
COPY server.xml ${TOMCAT_HOME}/conf/server.xml

VOLUME ["/logs"]
EXPOSE 8080