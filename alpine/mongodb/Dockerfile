FROM supermy/alpine
#FROM alpine:edge

MAINTAINER JamesMo <springclick@gmail.com>

RUN apk update
RUN apk add mongodb --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
VOLUME /data/db
VOLUME /mongodb/backup
ADD docker_entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 27017
CMD ["mongod"]