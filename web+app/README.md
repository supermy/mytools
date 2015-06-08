web（极限性能挖掘，可快速扩充）
====================

介绍
---------------------
nginx(tengine)+tomcat+mysql+memcached 集群
一键构造，一键启动，一键数据初始化。

>   nginx 整合HttpRedis2Module/lua-resty-redis完成，http方式访问redis;
>   mysql2redis.sh 将mysql 的数据同步到redis,通过linux 的crontab 进行配置；
>
> ## end