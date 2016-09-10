FROM  supermy/alpine

MAINTAINER JamesMo <springclick@gmail.com>

ENV LANG       zh_CN.UTF-8
ENV LANGUAGE   zh_CN:zh


#RUN apk add --no-cache --update-cache bash

RUN apk add --no-cache --virtual .build-deps \
        build-base
RUN apk add --no-cache libstdc++

RUN echo "Asia/Shanghai" > /etc/timezone
ADD localtime /etc/localtime

CMD ["/bin/bash"]

#ENTRYPOINT ["bash"]