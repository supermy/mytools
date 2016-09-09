#todo 中文环境支持
# Dockerfile - alpine
# https://github.com/openresty/docker-openresty

FROM supermy/alpine

MAINTAINER JamesMo <springclick@gmail.com>

WORKDIR /app
VOLUME /app
COPY startup.sh /startup.sh
RUN chmod a+x /startup.sh

RUN apk add --no-cache --update mysql mysql-client && rm -f /var/cache/apk/*
#RUN apk add --update mysql && rm -f /var/cache/apk/*


COPY my.cnf /etc/mysql/my.cnf

EXPOSE 3306
CMD ["/startup.sh"]