mytools
=======

基于debian的images文件小，但是速度慢；基于ubuntu的文件大但是速度快。why

应用场景：wordpress,mysql  性能不好
    下载安排
    docker pull mysql:latest
    docker pull wordpress:latest
    启动环境
    docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=mysecretpassword -d mysql  //        "IPAddress": "172.17.0.2",
    docker run --name some-wordpress --link some-mysql:mysql -p 8081:80 -d wordpress    //"IPAddress": "172.17.0.3",
    测试
        #不允许远程访问
        boot2docker ssh -L 60001:localhost:3306 //可以在用户环境测试3306端口
        mysql -port 60001 -u mysql -pmysql
    boot2docker ssh -L 8081:localhost:8081
    http://localhost:8081
    自动进入安装界面
    http://127.0.0.1:8081/wp-admin/install.php?step=1
    安装完成之后进入登陆见面
    http://127.0.0.1:8081/wp-login.php    
  
应用场景：DB4Oracle  性能可以

    docker pull wnameless/oracle-xe-11g:latest
    docker run -d -p 49160:22 -p 49161:1521 wnameless/oracle-xe-11g 
    
    hostname: localhost port: 49161 sid: xe username: system password: oracle
    Password for SYS  oracle
    Login by SSH  ssh root@localhost -p 49160 password: admin
    #>su oracle
    oracle>sqlplus system/oracle
    sql>select * from dual
    boot2docker ssh -L 49166:localhost:49161   //49166是本机接收端口，49161是docker转出端口
    OracleSqlDeveloper 建立链接进行测试，成功。
    
应用场景：app-server tomcat 没有优化，没有集群

    docker pull tutum/tomcat
    启动服务
    docker run -d -p 8082:8080 -p 22 tutum/tomcat
    docker run -d -p 8080:8080 -e TOMCAT_PASS="mypass" tutum/tomcat  //制定口令
    看tomcat日志
    docker logs e7de45dad550
    tomcat-server,admin:uo8FsDhjjuUk
    http://127.0.0.1:8082/manager/status
    
应用场景：web-server nginx  可制定显示内容和优化配置文件  性能 ok
    docker pull nginx:latest //https://registry.hub.docker.com/_/nginx/
    
    DockerFile:构建自己的nginx-web
        FROM nginx
        COPY static-html-directory /usr/share/nginx/html
        
        docker build -t some-content-nginx 
        docker run --name some-nginx -d some-content-nginx
       
    mkdir some/content
    echo 'hello,word'>some/content/index.html
    #一个本地主机的目录当做数据卷挂载在容器上,[host-dir]:[container-dir]:[rw|ro]
    docker run --net=host --name some-nginx -v /home/docker/some/content:/usr/share/nginx/html:ro -d nginx
    
    
    curl 172.17.0.6/index.html
    
    docker run -rm --volumes-from DATA -v $(pwd):/backup busybox tar cvf /backup/backup.tar /data
    创建一个新容器，挂载数据卷容器，同时挂载一个本地目录，然后把远程数据卷容器的数据卷通过备份命令备份到映射的本地目录里面。
        

    使用本地的配置文件运行容器    
    docker run --name some-nginx -v /some/nginx.conf:/etc/nginx/nginx.conf:ro -d nginx
    docker cp some-nginx:/etc/nginx/nginx.conf some/nginx.conf
    
应用场景：nosql-mongodb 性能不错；没有集群
    
    docker pull mongo:latest
    docker run --name some-mongo -d mongo
    boot2docker ssh -L 27017:172.17.0.7:27017
    
    
应用场景：缓存服务器-memcached/redis ,可配置内存和链接数
    
    docker pull sylvainlasnier/memcached
    docker run --name memcached -d -p 50006:11211 sylvainlasnier/memcached
    docker run --rm -ti -e MAX_MEM=1024,MAX_CONN=10000 sylvainlasnier/memcached
    
    $nc 127.0.0.1 50006
    stats
    
    docker pull redis
    docker run --name some-redis -p 6379 -d redis
    
    #自定义redis配置参数
        FROM redis
        redis.conf /data/
        CMD [ "redis-server", "/data/redis.conf" ]
    docker run --volumes-from datacontainer --name myredis redis
----------------------------------------------------------------------    
集群todo

# 第一个-d表示让容器在后台运行
# 末尾的-D表示启动ssh的daemon模式，不然容器启动后立刻就变为停止状态了
docker run -i -t --name mydebian debian:latest
直接访问容器
docker run -i -t CONTAINER_ID /bin/bash


******************************************************************
todo 
    oracle-java7环境
    全文检索：solr 环境 含中文分词
    规则殷勤：drools 平台使用
    工作流：activiti
    云平台: 
    
******************************************************************
#遇到的问题
/etc/hosts文件无法修改，这样你就不能自己做域名解析
VM的系统时间是UTC +0000的，而且貌似无法修改
Container的IP无法指定为静态IP，因此每次重启Container时，IP可能会变化

#绑定本地磁盘目录到容器目录
brew install sshfs 
cat tcuser > ~/.boot2docker/b2d-passwd 
#绑定本地目录到docker
sshfs docker@localhost:/mnt/sda1/dev ~/workspace/dev -p 2022 -o reconnect -o password_stdin < ~/.boot2docker/b2d-passwd 
#绑定docker目录到容器
docker run -i -t dev:base -v /mnt/sda1/dev:/src /bin/bash

#端口由容器内影射到本地机器
boot2docker ssh -L 8000:localhost:8000 
docker run -i -t -p 8000:8000

#Docker使用dnsmasq替代/etc/hosts解析
http://knktc.com/2014/08/16/docker-use-dnsmasq-as-hosts/

 
基于Docker，构造测试和生产环境。
base debian nginx(淘宝)+tomcat+memcache 集群 
mongodb集群 
mysql集群 
oracle单机版 

全文检索：solr 
工作流：activity 
规则引擎：drools

dns容器ip地址配置； 

php框架
springmvc框架

web框架：jquery-mobile，extjs

docker build -t mydev/debian test

docker build -t mydb/mysql mysql

