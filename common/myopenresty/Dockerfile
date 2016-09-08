#FROM gliderlabs/alpine:latest
FROM supermy/base-alpine:latest


MAINTAINER JamesMo

RUN apk update && \
    apk add curl git openssh-client ca-certificates openssl-dev make gcc g++ musl-dev perl \
            bash wget tar gzip unzip && \
    rm /var/cache/apk/*

ENV PCRE_VERSION      8.38
ENV OPENRESTY_VERSION 1.9.7.4
ENV LUAROCKS_VERSION  2.3.0

RUN cd /tmp && \
    wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${PCRE_VERSION}.tar.gz && \
    tar zxf pcre-${PCRE_VERSION}.tar.gz

# openresty
RUN cd /tmp && \
    wget https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz && \
    tar zxf openresty-${OPENRESTY_VERSION}.tar.gz && \
    cd openresty-${OPENRESTY_VERSION} && \
    ./configure --with-luajit --prefix=/usr/local \
        --with-pcre=/tmp/pcre-${PCRE_VERSION} --with-pcre-jit \
        --with-luajit-xcflags=-DLUAJIT_ENABLE_LUA52COMPAT \
        --http-client-body-temp-path=/var/nginx/client_body_temp \
        --http-proxy-temp-path=/var/nginx/proxy_temp \
        --http-log-path=/var/nginx/access.log \
        --error-log-path=/var/nginx/error.log \
        --pid-path=/var/nginx/nginx.pid \
        --lock-path=/var/nginx/nginx.lock \
        --with-http_gunzip_module \
        --with-http_stub_status_module \
        --with-http_ssl_module \
        --with-http_realip_module \
        --without-http_fastcgi_module \
        --without-http_uwsgi_module \
        --without-http_scgi_module \
        --with-md5-asm \
        --with-sha1-asm && \
    make && \
    make install && \
    rm -rf openresty-* && \
    rm -rf pcre-*

# luarocks
RUN cd /tmp && \
    wget http://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz && \
    tar -xzvf luarocks-${LUAROCKS_VERSION}.tar.gz && \
    cd luarocks-${LUAROCKS_VERSION}/ && \
    ./configure --prefix=/usr/local/luajit \
        --with-lua=/usr/local/luajit/ \
        --with-lua-include=/usr/local/luajit/include/luajit-2.1 \
        --lua-suffix=jit && \
    make && \
    make install && \
    rm -rf luarocks-*

# symlink
RUN ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx && \
    ln -s /usr/local/luajit/bin/luajit /usr/bin/lua && \
    ln -s /usr/local/luajit/bin/luarocks /usr/bin/luarocks
