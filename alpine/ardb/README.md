2017-04-20

   Ardb是一个新的构建在持久化Key/Value存储实现上的NoSQL DB服务实现，支持list/set/sorted set/bitset/hash/table等复杂的数据结构，以Redis协议对外提供访问接口。
   
   Ardb的基本特性如下：
   
   完全兼容Redis协议，支持绝大部分Redis命令的高性能持久化NoSQL DB；
    支持多种持久化Key/Value存储引擎（LevelDB/KyotoCabinet/LMDB）
   支持主从复制/主主复制，在线备份
   除set/zset/list/hash外, 支持简单的Table数据结构以及类似SQL的查询
   优化的bitset实现
   性能测试数据参考项目首页
    
