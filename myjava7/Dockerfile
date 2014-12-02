FROM mydev/debian:latest

RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get -y install oracle-java7-installer && \
    update-alternatives --display java && \
    apt-get -y install oracle-java7-set-default && \
    rm -fr /var/cache/oracle-jdk7-installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG       zh_CN.UTF-8
ENV LC_ALL     zh_CN.UTF-8
ENV LANGUAGE   zh_CN:zh

ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

#build -t myjava7/debian oracle-java7