FROM supermy/ap-nodejs

MAINTAINER james mo <springclick@gmail.com>

LABEL com.stdmachine.description="alpine netdata image" \
      com.stdmachine.role="netdata image"

ENV PORT=19999 \
    SECONDS=1

RUN addgroup -S netdata && adduser -D -H -G netdata netdata && \
    apk add gawk curl jq libuuid --no-cache && \
    apk add git zlib-dev automake autoconf build-base linux-headers musl-dev util-linux-dev libmnl-dev -t buildpack --no-cache
RUN git clone https://github.com/firehol/netdata.git --depth=1
#&& \
RUN  cd netdata &&chmod a+x netdata-installer.sh
RUN  cd netdata && ./netdata-installer.sh --dont-wait
#    apk del buildpack --purge --no-cache && rm -rf /tmp/* /var/apk/cache* /root/.wget-htst

EXPOSE ${PORT}
CMD ["/usr/sbin/netdata", "-D","-t","${SECONDS}","-p","${PORT}"]
#
## install required packages
#RUN apk add alpine-sdk bash curl zlib-dev util-linux-dev libmnl-dev gcc make git autoconf automake pkgconfig python logrotate
#
## add the netdata user and group by had
## the installer uses the commands useradd and groupadd,
## but these are not available in alpine
#RUN addgroup netdata &&\
#    adduser -D -G netdata netdata
## if you plan to run node.js netdata plugins
##apk add nodejs
#
## make netdata start at boot
#RUN echo -e "#!/usr/bin/env bash\n/usr/sbin/netdata" >/etc/local.d/netdata.start && \
#    chmod 755 /etc/local.d/netdata.start &&\
## make netdata stop at shutdown
#    echo -e "#!/usr/bin/env bash\nkillall netdata" >/etc/local.d/netdata.stop &&\
#    chmod 755 /etc/local.d/netdata.stop &&\
## enable the local service to start automatically
#    rc-update add local &&\
## download netdata - the directory 'netdata' will be created
#RUN git clone https://github.com/firehol/netdata.git --depth=1  &&\
#    cd netdata &&\
## build it, install it, start it
#    chmod a+x netdata-installer.sh && ./netdata-installer.sh
