#增加WAF 防火墙

FROM supermy/ap-ssl

MAINTAINER JamesMo <springclick@gmail.com>


#安装后缺规则文件
#RUN opm get p0pr0ck5/lua-resty-waf

# 最新版本 luarocks install lua-resty-waf
RUN \
    apk add --no-cache --virtual .build-deps \
        build-base &&\
     echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories &&\
     apk add --no-cache  lua-dev python pcre pcre-dev openssl-dev git mongo-c-driver  mongo-c-driver-dev


#家里网络不通 luarocks install luacrypto && luarocks install resty-mongol &&
RUN luarocks install lrexlib-pcre && luarocks install lua-resty-waf && \
    luarocks install mongorover && luarocks install lua-resty-libcjson  && \
    luarocks install lua-resty-fileinfo && luarocks install lua-resty-snappy  && luarocks install lua-resty-tags  && \
    luarocks install luafilesystem && luarocks install lua-resty-uuid

RUN opm get bungle/lua-resty-template &&    opm get bungle/lua-resty-prettycjson && \
    opm get bungle/lua-resty-reqargs && opm get bungle/lua-resty-validation  && \
    opm get bungle/lua-resty-nettle  && opm get openresty/lua-resty-websocket && \
    opm get openresty/lua-resty-limit-traffic &&  opm get antonheryanto/lua-resty-post &&\
    opm get bungle/lua-resty-session  && opm get thibaultcha/lua-resty-jit-uuid

RUN apk del .build-deps


#重构 todo
COPY conf/http.d/lua-init.conf /usr/local/openresty/nginx/conf/http.d/
COPY conf/server.d/session-server.conf /usr/local/openresty/nginx/conf/server.d/

COPY conf/location-waf.conf /usr/local/openresty/nginx/conf/
COPY conf/nginx.conf /usr/local/openresty/nginx/conf/
COPY conf/server.conf /usr/local/openresty/nginx/conf/

COPY src/ /usr/local/openresty/site/lualib/


#EXPOSE 80 443

#ENTRYPOINT ["/usr/local/openresty/nginx/sbin/nginx", "-g", "daemon off;"]

#docker run -it -p 80:80 -p 443:443 supermy/ap-waf

#部署完毕可以尝试如下命令：
#
#    curl http://xxxx/test.php?id=../etc/passwd
#    返回警报信息字样，说明规则生效。
#
