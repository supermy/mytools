#增加WAF 防火墙

FROM supermy/ap-ssl

MAINTAINER JamesMo <springclick@gmail.com>


RUN opm get bungle/lua-resty-session
#安装后缺规则文件
#RUN opm get p0pr0ck5/lua-resty-waf

# 最新版本 luarocks install lua-resty-waf
RUN apk add --no-cache  lua-dev python pcre pcre-dev && \
     luarocks install lrexlib-pcre  && \
     luarocks install lua-resty-waf

#RUN luarocks install luacrypto
#RUN luarocks install resty-mongol


RUN opm get bungle/lua-resty-template &&    opm get bungle/lua-resty-prettycjson && \
    opm get openresty/lua-resty-upstream-healthcheck    && opm get openresty/lua-resty-redis
#opm get bungle/lua-resty-uuid && &&  \ opm get openresty/lua-resty-mysql



#重构 todo
COPY conf/http.d/lua-init.conf /usr/local/openresty/nginx/conf/http.d/
COPY conf/location-waf.conf /usr/local/openresty/nginx/conf/
COPY conf/nginx.conf /usr/local/openresty/nginx/conf/
COPY conf/server.conf /usr/local/openresty/nginx/conf/
#EXPOSE 80 443

#ENTRYPOINT ["/usr/local/openresty/nginx/sbin/nginx", "-g", "daemon off;"]

#docker run -it -p 80:80 -p 443:443 supermy/ap-waf

#部署完毕可以尝试如下命令：
#
#    curl http://xxxx/test.php?id=../etc/passwd
#    返回警报信息字样，说明规则生效。
#
