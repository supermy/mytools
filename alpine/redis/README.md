2016-08-25
    启动实例
    $ docker run  -d -p 6379  supermy/ap-redis
    持久化配置
    $ docker run --name some-redis -d redis redis-server --appendonly yes
    链接到应用
    $ docker run --name some-app --link some-redis:redis -d application-that-uses-redis
    应用到redis-cli
    $ docker run -it --link some-redis:redis --rm redis redis-cli -h redis -p 6379
    自定义配置文件启动
    $ docker run -v /myredis/conf/redis.conf:/usr/local/etc/redis/redis.conf 
        --name myredis redis redis-server /usr/local/etc/redis/redis.conf


    
2016-06-23
    8M  迷你
    docker pull redis:alpine   
    docker run --name some-redis -d redis:alpine
    
    #启动持久化存储，制定存储到本地绑定目录 -v /docker/host/dir:/data
    docker run --name some-redis -d redis redis-server --appendonly yes
    
    connect to it from an application
    $ docker run --name some-app --link some-redis:redis -d application-that-uses-redis
    ... or via redis-cli
    $ docker run -it --link some-redis:redis --rm redis redis-cli -h redis -p 6379
   
    