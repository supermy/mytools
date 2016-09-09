FROM supermy/ap-jre

MAINTAINER JamesMo <springclick@gmail.com>

ENV ELASTICSEARCH_MAJOR 2.2
ENV ELASTICSEARCH_VERSION 2.2.0
ENV ELASTICSEARCH_URL_BASE https://download.elasticsearch.org/elasticsearch/elasticsearch
ENV PATH /opt/elasticsearch/bin:$PATH

#RUN set -ex \
#	&& apk --update add bash curl \
#	&& rm -rf /var/cache/apk/*
#RUN curl -fsSL -o /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.0/dumb-init_1.0.0_amd64 \
#	&& chmod 0755 /usr/bin/dumb-init
#RUN set -x \
#	&& curl -fsSL -o /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.3/gosu-amd64 \
#	&& chmod +x /usr/local/bin/gosu
COPY gosu-amd64 /usr/local/bin/gosu
RUN chmod a+x /usr/local/bin/gosu

COPY dumb-init_1.0.0_amd64 /usr/bin/dumb-init
RUN chmod 0755 /usr/bin/dumb-init

RUN apk add --no-cache   bash  curl  wget

RUN  mkdir -p /opt \
	&& curl -fsSL -o /tmp/elasticsearch.tar.gz $ELASTICSEARCH_URL_BASE/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz \
	&& tar -xzf /tmp/elasticsearch.tar.gz -C /opt \
	&& rm -f /tmp/elasticsearch.tar.gz \
	&& mv /opt/elasticsearch-$ELASTICSEARCH_VERSION /opt/elasticsearch \
	&& for path in \
		/opt/elasticsearch/data \
		/opt/elasticsearch/logs \
		/opt/elasticsearch/config \
		/opt/elasticsearch/config/scripts; do mkdir -p "$path"; done \
	&& addgroup elasticsearch \
	&& adduser -D -G elasticsearch -h /opt/elasticsearch elasticsearch \
	&& chown -R elasticsearch:elasticsearch /opt/elasticsearch

COPY config /opt/elasticsearch/config



VOLUME /opt/elasticsearch/data

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9200 9300

CMD ["elasticsearch"]