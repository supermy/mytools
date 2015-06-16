#转移到common/mysql
FROM    mysql:latest
MAINTAINER jamesmo <springclick@gmail.com>


#配置时区
RUN echo "Asia/Shanghai" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata
