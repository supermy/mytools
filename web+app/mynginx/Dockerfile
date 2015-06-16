FROM    debian:latest

MAINTAINER jamesmo <springclick@gmail.com>

RUN sed -i '1,3d'   /etc/apt/sources.list
RUN echo '#hello'>> /etc/apt/sources.list

RUN sed -i '1a \
    deb http://mirrors.163.com/debian/ wheezy main non-free contrib \n \
    deb http://mirrors.163.com/debian/ wheezy-proposed-updates main contrib non-free \n \
    deb http://mirrors.163.com/debian-security/ wheezy/updates main contrib non-free \n \
    deb-src http://mirrors.163.com/debian/ wheezy main non-free contrib \n \
    deb-src http://mirrors.163.com/debian/ wheezy-proposed-updates main contrib non-free \n \
    deb-src http://mirrors.163.com/debian-security/ wheezy/updates main contrib non-free \n \
    ' /etc/apt/sources.list

# sohu 更新服务器：
#RUN sed -i '1a \
#    deb http://mirrors.sohu.com/debian/ wheezy main non-free contrib  \
#    deb http://mirrors.sohu.com/debian/ wheezy-proposed-updates main non-free contrib \
#    deb http://mirrors.sohu.com/debian-security/ wheezy/updates main contrib non-free \n \
#    deb-src http://mirrors.sohu.com/debian/ wheezy main non-free contrib \
#    deb-src http://mirrors.sohu.com/debian/ wheezy-proposed-updates main non-free contrib \
#    deb-src http://mirrors.sohu.com/debian-security/ wheezy/updates main contrib non-free \n \
#    ' /etc/apt/sources.list

#    deb http://ftp.sjtu.edu.cn/debian/ wheezy main non-free contrib \n \
#    deb http://ftp.sjtu.edu.cn/debian/ wheezy-proposed-updates main contrib non-free \n \
#    deb http://ftp.sjtu.edu.cn/debian-security/ wheezy/updates main contrib non-free \n \
#    deb-src http://ftp.sjtu.edu.cn/debian/ wheezy main non-free contrib \n \
#    deb-src http://ftp.sjtu.edu.cn/debian/ wheezy-proposed-updates main contrib non-free \n \
#    deb-src http://ftp.sjtu.edu.cn/debian-security/ wheezy/updates main contrib non-free \n \

RUN cat /etc/apt/sources.list

RUN apt-get -qqy update && \
    apt-get -qqy install gcc libpcre3 libpcre3-dev openssl libssl-dev make wget libreadline-dev libncurses-dev graphicsmagick

WORKDIR /tmp
RUN wget http://tengine.taobao.org/download/tengine-2.1.0.tar.gz
RUN tar xvf tengine-2.1.0.tar.gz

#lua5.3不支持cjson LuaBitOp，降级到lua-5.1.5
WORKDIR /tmp
RUN wget http://www.lua.org/ftp/lua-5.1.5.tar.gz
RUN tar zxf lua-5.1.5.tar.gz
WORKDIR /tmp/lua-5.1.5
RUN make linux && make install

#配置 openrestry
WORKDIR /tmp
RUN wget  http://luajit.org/download/LuaJIT-2.0.4.tar.gz
RUN wget http://www.kyne.com.au/~mark/software/download/lua-cjson-2.1.0.tar.gz
RUN wget -e "http_proxy=http://172.16.70.18:8087" http://openresty.org/download/ngx_openresty-1.7.10.1.tar.gz
RUN wget http://labs.frickle.com/files/ngx_cache_purge-2.3.tar.gz


# mysql depends bit ,不兼容lua-5.3.0 ,兼容lua-5.2.0
RUN wget -e "http_proxy=http://172.16.70.18:8087" http://bitop.luajit.org/download/LuaBitOp-1.0.2.tar.gz

RUN tar zxf LuaJIT-2.0.4.tar.gz
RUN tar zxf lua-cjson-2.1.0.tar.gz
RUN tar zxf ngx_openresty-1.7.10.1.tar.gz
RUN tar zxf LuaBitOp-1.0.2.tar.gz
RUN tar zxf ngx_cache_purge-2.3.tar.gz


WORKDIR /tmp/LuaJIT-2.0.4
RUN make && make install

WORKDIR /tmp/lua-cjson-2.1.0
RUN make && make install

# mysql 需要luajit 或者 LuaBitOp
WORKDIR /tmp/ngx_openresty-1.7.10.1
RUN ./configure --prefix=/usr/local/openresty --with-luajit && make && make install


WORKDIR /tmp/LuaBitOp-1.0.2
RUN make && make install


#配置 openrestry end


RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf

WORKDIR /tmp/tengine-2.1.0
RUN \
    cd /tmp/tengine-2.1.0 &&\
    ./configure  \
       --with-ld-opt='-Wl,-rpath,/usr/local/lib/' \
        --add-module=/tmp/ngx_openresty-1.7.10.1/bundle/redis2-nginx-module-0.11/ \
        --add-module=/tmp/ngx_openresty-1.7.10.1/bundle/ngx_devel_kit-0.2.19/ \
        --add-module=/tmp/ngx_openresty-1.7.10.1/bundle/set-misc-nginx-module-0.28/ \
        --add-module=/tmp/ngx_openresty-1.7.10.1/bundle/echo-nginx-module-0.57/ \
        --add-module=/tmp/ngx_openresty-1.7.10.1/bundle/ngx_lua-0.9.15/ \
        --add-module=/tmp/ngx_cache_purge-2.3/ \
    && make && make install


ADD nginx.conf /usr/local/nginx/conf/nginx.conf


WORKDIR /root
RUN rm -rf /tmp/tengine-*
RUN rm -rf /tmp/lua-*

ENV HOME /root
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN mkdir -p /etc/my_init.d
COPY nginx.d /usr/local/nginx/conf/nginx.d
ADD nginx.sh /etc/my_init.d/nginx.sh
RUN chmod 755 /etc/my_init.d/nginx.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/lib/nginx/cache

#配置时区
RUN echo "Asia/Shanghai" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

EXPOSE 80 443

CMD ["/etc/my_init.d/nginx.sh"]

# build
# docker build -t jamesmo/mynginx:2.1 .
# userage
# docker run -d -p 8080:80 --name test -v /home/utgard/www/:/data/www/ mynginx_web