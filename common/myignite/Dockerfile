FROM supermy/docker-jre:ap

MAINTAINER JamesMo <springclick@gmail.com>

WORKDIR /tmp

RUN wget -nv http://mirrors.ircam.fr/pub/apache//incubator/ignite/1.0.0/ignite-fabric-1.0.0-incubating.zip \
 && unzip -q ignite-fabric-1.0.0-incubating.zip \
 && rm -f ignite-fabric-1.0.0-incubating.zip

WORKDIR /ignite-fabric-1.0.0-incubating/bin

COPY default-config.xml ../config/

EXPOSE 47100


CMD /ignite-fabric-1.0.0-incubating/bin/ignite.sh