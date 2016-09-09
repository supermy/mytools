#增加WAF 防火墙

FROM supermy/ap-openresty

MAINTAINER JamesMo <springclick@gmail.com>

ARG RESTY_WAF_VERSION="master"
ARG RESTY_NAME_VERSION="lua-resty-waf"
ARG LUA_LIB_DIR="/usr/local/openresty/lualib"

RUN curl --insecure -fSL https://github.com/p0pr0ck5/lua-resty-waf/archive/${RESTY_WAF_VERSION}.tar.gz -o ${RESTY_NAME_VERSION}.tar.gz \
    && tar xzf ${RESTY_NAME_VERSION}.tar.gz \
    && ls lua-resty-waf-master \
    && cp -r ${RESTY_NAME_VERSION}-${RESTY_WAF_VERSION}/lib/resty/* ${LUA_LIB_DIR}/resty/  \
    && cp -r ${RESTY_NAME_VERSION}-${RESTY_WAF_VERSION}/lib/*.so ${LUA_LIB_DIR} \
    && cp -r ${RESTY_NAME_VERSION}-${RESTY_WAF_VERSION}/rules/ ${LUA_LIB_DIR}

#EXPOSE 80 443

#ENTRYPOINT ["/usr/local/openresty/nginx/sbin/nginx", "-g", "daemon off;"]