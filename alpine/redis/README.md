2016-09-18
##主从模式
####docker run --net=host --name=master supermy/ap-redis
####docker run --net=host --name=slave -d supermy/ap-redis redis-server --port 6380 --slaveof 127.0.0.1 6379
*   docker exec -it master redis-cli
*   set aaa 123
*   keys *
*   get aaa
*   exit
*   docker exec -it slave redis-cli
*   keys *
*   get aaa
-   返回数据是123,数据已经同步
*   exit
####docker rm -f master slave
##集群

>    cat << EOF > redis1.conf   
 
    port 6381
    cluster-enabled yes
    cluster-config-file nodes.conf
    cluster-node-timeout 5000
    appendonly yes
    EOF
    
>    cp redis1.conf redis2.conf

    sed -i '' 's/6381/6382/' redis2.conf
    
>    cp redis1.conf redis3.conf

    sed -i ''  's/6381/6383/' redis3.conf

>   net=host to fix me 
    docker run -p 6381:6381 --name=redis1 -v `pwd`/redis1.conf:/usr/local/etc/redis/redis.conf -d supermy/ap-redis redis-server /usr/local/etc/redis/redis.conf
    docker run -p 6382:6382 --name=redis2 -v `pwd`/redis2.conf:/usr/local/etc/redis/redis.conf -d supermy/ap-redis redis-server /usr/local/etc/redis/redis.conf
    docker run -p 6383:6383 --name=redis3 -v `pwd`/redis3.conf:/usr/local/etc/redis/redis.conf -d supermy/ap-redis redis-server /usr/local/etc/redis/redis.conf


*   git clone https://github.com/antirez/redis

*   sudo gem install redis

*   ruby redis-trib.rb create 127.0.0.1:6381 127.0.0.1:6382 127.0.0.1:6383

>
    docker exec -it redis1 redis-cli -p 6381
    cluster nodes
    set aaa 123
    set bbb 234
    exit

>   redis-cli提供了一个-c的参数，允许以集群的方式连接
    docker exec -it redis1 redis-cli -c -p 6381
    set bbb 234
    keys *
    exit

####docker rm -f redis1 redis2 redis3


##主从集群
>
cp redis1.conf redis4.conf
cp redis1.conf redis5.conf
cp redis1.conf redis6.conf

sed -i 's/6381/6384/' redis4.conf
sed -i 's/6381/6385/' redis5.conf
sed -i 's/6381/6386/' redis6.conf

docker run --net=host --name=redis1 -v `pwd`/redis1.conf:/usr/local/etc/redis/redis.conf -d supermy/ap-redis redis-server /usr/local/etc/redis/redis.conf
docker run --net=host --name=redis2 -v `pwd`/redis2.conf:/usr/local/etc/redis/redis.conf -d supermy/ap-redis redis-server /usr/local/etc/redis/redis.conf
docker run --net=host --name=redis3 -v `pwd`/redis3.conf:/usr/local/etc/redis/redis.conf -d supermy/ap-redis redis-server /usr/local/etc/redis/redis.conf
docker run --net=host --name=redis4 -v `pwd`/redis4.conf:/usr/local/etc/redis/redis.conf -d supermy/ap-redis redis-server /usr/local/etc/redis/redis.conf
docker run --net=host --name=redis5 -v `pwd`/redis5.conf:/usr/local/etc/redis/redis.conf -d supermy/ap-redis redis-server /usr/local/etc/redis/redis.conf
docker run --net=host --name=redis6 -v `pwd`/redis6.conf:/usr/local/etc/redis/redis.conf -d supermy/ap-redis redis-server /usr/local/etc/redis/redis.conf

####ruby redis/src/redis-trib.rb create --replicas 1 127.0.0.1:6381 127.0.0.1:6382 127.0.0.1:6383 127.0.0.1:6384 127.0.0.1:6385 127.0.0.1:6386
####docker rm -f redis1 redis2 redis3 redis4 redis5 redis6



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

    docker run --name some-redis -d redis

    
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
   
    