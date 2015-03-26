FROM    debian:latest

#2015-01-24修订,中文语言
MAINTAINER JamesMo <springclick@gmail.com>

RUN sed -i '1,3d'   /etc/apt/sources.list
RUN echo '#hello'>> /etc/apt/sources.list

RUN sed -i '1a \
    deb http://mirrors.163.com/debian/ wheezy main non-free contrib \n \
    deb http://mirrors.163.com/debian/ wheezy-proposed-updates main contrib non-free \n \
    deb http://mirrors.163.com/debian-security/ wheezy/updates main contrib non-free \n \
    deb-src http://mirrors.163.com/debian/ wheezy main non-free contrib \n \
    deb-src http://mirrors.163.com/debian/ wheezy-proposed-updates main contrib non-free \n \
    deb-src http://mirrors.163.com/debian-security/ wheezy/updates main contrib non-free \n \
    deb http://ftp.sjtu.edu.cn/debian/ wheezy main non-free contrib \n \
    deb http://ftp.sjtu.edu.cn/debian/ wheezy-proposed-updates main contrib non-free \n \
    deb http://ftp.sjtu.edu.cn/debian-security/ wheezy/updates main contrib non-free \n \
    deb-src http://ftp.sjtu.edu.cn/debian/ wheezy main non-free contrib \n \
    deb-src http://ftp.sjtu.edu.cn/debian/ wheezy-proposed-updates main contrib non-free \n \
    deb-src http://ftp.sjtu.edu.cn/debian-security/ wheezy/updates main contrib non-free \n \
    ' /etc/apt/sources.list

RUN cat /etc/apt/sources.list

RUN apt-get -qq update  &&  apt-get -qq upgrade

RUN     apt-get -y install locales && \
        sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen && \
        locale-gen && \
        update-locale LC_ALL= "zh_CN.UTF-8" && \
        export LANGUAGE=zh_CN && \
        export LANG=zh_CN.UTF-8 && \
        locale

RUN	   apt-get install -qq curl
RUN    apt-get -qq install wget
RUN    apt-get -qq install sudo

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
	&& curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu


ENV LANG       zh_CN.UTF-8
ENV LANGUAGE   zh_CN:zh

#userage
#docker build -t mydebian mydebian