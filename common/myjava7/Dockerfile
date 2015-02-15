FROM mydebian_base

## Install Oracle JDK
RUN wget --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz

RUN mkdir /opt/jdk
RUN tar -zxf jdk-7u67-linux-x64.tar.gz -C /opt/jdk
RUN rm jdk-7u67-linux-x64.tar.gz
RUN update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.7.0_67/bin/java 100
RUN update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.7.0_67/bin/javac 100
ENV JAVA_HOME /opt/jdk/jdk1.7.0_67/

RUN    apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*