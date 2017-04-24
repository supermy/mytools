FROM supermy/ap-openresty

MAINTAINER JamesMo <springclick@gmail.com>

#安装 luarocks
RUN \
    apk add --no-cache --virtual .build-deps \
        build-base \
        git &&\
    cd /tmp && \
    git clone https://github.com/keplerproject/luarocks.git && \
    cd luarocks && \
    sh  ./configure --prefix=/usr/local/openresty/luajit \
                   --with-lua=/usr/local/openresty/luajit/ \
                   --lua-suffix=jit \
                   --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 && \
    make build install && \
    cd && \
    rm -rf /tmp/luarocks
ENV PATH="/usr/local/openresty/bin:/usr/local/openresty/luajit/bin:${PATH}"

#apk del .build-deps && \


#安装 ssl
#libc-dev=g++   grep  sed
RUN apk add --no-cache  openssl gcc g++ perl&& \
     opm get pintsized/lua-resty-http  && \
    luarocks install lua-resty-auto-ssl && \
    mkdir /etc/resty-auto-ssl  && \
    openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 \
       -subj '/CN=sni-support-required-for-valid-ssl' \
       -keyout /etc/ssl/resty-auto-ssl-fallback.key \
       -out /etc/ssl/resty-auto-ssl-fallback.crt    &&\
    apk del .build-deps
    #&& \
#RUN    chmod +x /usr/local/openresty/luajit/share/lua/5.1/resty/auto-ssl/shell/* &&\
RUN    chmod +x /usr/local/openresty/luajit/share/lua/5.1/resty/auto-ssl/vendor/*

#准备配置的启动文件
COPY conf/* /usr/local/openresty/nginx/conf/
RUN mkdir /usr/local/openresty/nginx/conf/http.d/
COPY conf/http.d/lua-init.conf /usr/local/openresty/nginx/conf/http.d/


#&& chown www-data /etc/resty-auto-ssl

#docker run -it -p 80:80 -p 443:443 supermy/ap-ssl
#curl -k https://example.com/
#curl -k http://example.com/

