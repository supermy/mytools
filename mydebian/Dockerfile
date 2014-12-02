FROM    debian:latest

RUN    export DEBIAN_FRONTEND=noninteractive && \
        apt-get update && \
        apt-get upgrade -y
RUN    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
       echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
       apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

RUN    apt-get update && \
        apt-get -y install locales && \
        sed -i.bak -e 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen && \
        locale-gen && \
        update-locale LC_ALL= "zh_CN.UTF-8" && \
        export LANGUAGE=zh_CN && \
        export LANG=zh_CN.UTF-8 && \
        export LC_ALL=zh_CN.UTF-8 && \
        dpkg-reconfigure locales && \
        locale


RUN	   apt-get install -y curl

RUN    apt-get clean && \
       rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.1/gosu' \
	&& chmod +x /usr/local/bin/gosu

ENV LANG       zh_CN.UTF-8
ENV LC_ALL     zh_CN.UTF-8
ENV LANGUAGE   zh_CN:zh

#userage
#docker build -t mydev/debian mydebian