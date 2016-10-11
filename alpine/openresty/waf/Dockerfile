#增加WAF 防火墙

FROM supermy/ap-openresty

MAINTAINER JamesMo <springclick@gmail.com>

ARG RESTY_WAF_VERSION="0.8"
ARG RESTY_NAME_VERSION="lua-resty-waf"

ARG RESTY_SESSION_VERSION="master"
ARG RESTY_SESSIONNAME_VERSION="lua-resty-session"


ARG LUA_LIB_DIR="/usr/local/openresty/lualib"

#waf-lua调用需要
#RUN apk add --no-cache --virtual .build-deps         build-base
RUN apk add --no-cache libstdc++

#https://github.com/bungle/lua-resty-session/archive/master.zip
#https://github.com/p0pr0ck5/lua-resty-waf/archive/v0.8.tar.gz

RUN curl --insecure -fSL https://github.com/p0pr0ck5/lua-resty-waf/archive/v${RESTY_WAF_VERSION}.tar.gz -o ${RESTY_NAME_VERSION}.tar.gz \
    && tar xzf ${RESTY_NAME_VERSION}.tar.gz \
    && cp -r ${RESTY_NAME_VERSION}-${RESTY_WAF_VERSION}/lib/resty/* ${LUA_LIB_DIR}/resty/  \
    && cp -r ${RESTY_NAME_VERSION}-${RESTY_WAF_VERSION}/lib/*.so ${LUA_LIB_DIR} \
    && cp -r ${RESTY_NAME_VERSION}-${RESTY_WAF_VERSION}/rules/ ${LUA_LIB_DIR} \
    && curl --insecure -fSL https://github.com/bungle/lua-resty-session/archive/${RESTY_SESSION_VERSION}.tar.gz -o ${RESTY_SESSIONNAME_VERSION}.tar.gz \
    && tar xzf ${RESTY_SESSIONNAME_VERSION}.tar.gz \
    && ls lua-resty-session-master \
    && cp -r ${RESTY_SESSIONNAME_VERSION}-${RESTY_SESSION_VERSION}/lib/resty/* ${LUA_LIB_DIR}/resty/  \
    && mkdir /usr/local/openresty/nginx/conf/http.d/ \
    && mkdir /usr/local/openresty/nginx/conf/server.d/

COPY conf/http-waf.conf /usr/local/openresty/nginx/conf/http.d/
COPY conf/location-waf.conf /usr/local/openresty/nginx/conf/
COPY conf/nginx.conf /usr/local/openresty/nginx/conf/
#EXPOSE 80 443

#ENTRYPOINT ["/usr/local/openresty/nginx/sbin/nginx", "-g", "daemon off;"]