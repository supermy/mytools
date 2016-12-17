FROM redis:alpine

MAINTAINER JamesMo <springclick@gmail.com>

ENV LANG       zh_CN.UTF-8
ENV LANGUAGE   zh_CN:zh


RUN echo "Asia/Shanghai" > /etc/timezone
ADD localtime /etc/localtime


CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]