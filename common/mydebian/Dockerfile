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



ENV LANG       zh_CN.UTF-8
ENV LANGUAGE   zh_CN:zh

#userage
#docker build -t mydebian mydebian