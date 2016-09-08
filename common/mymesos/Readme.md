Performance (Benchmark)
Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz

MemTotal: 16376596 kB

Twemproxy:
redis-benchmark -p 22121 -c 500 -n 5000000 -P 100 -r 10000 -t get,set

Codis:
redis-benchmark -p 19000 -c 500 -n 5000000 -P 100 -r 10000 -t get,set

For Java users who want to support HA
[Jodis (HA Codis Connection Pool based on Jedis)] (https://github.com/wandoulabs/codis/tree/master/extern/jodis)

https://github.com/xetorthio/jedis


管理界面
http://192.168.59.103:18087/admin/


问题：
    1.IP 地址的分配与互通；
    1.1使用宿主机的地址，采用不同的端口，固定解决;直接走宿主机地址，会因为网络IO，高并发的性能会不足。
    
    