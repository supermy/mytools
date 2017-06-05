微云（可快速扩充）
====================

MongoDB3.0-介绍
---------------------

基于 Docker 的 MongoDB 集群，可单机安装，也可以 k8s 安装。

* 通过 js 脚本进行集群数据初始化；
* Flume 采集数据入库 mongodb 配置示例；
* MongoDb 压力测试示例；
* Linux shell 脚本导入数据示例；



MongoDB把数据存储在文件中（默认路径为：/data/db），为提高效率使用内存映射文件进行管理。

压力测试工具
https://github.com/brianfrankcooper/YCSB/tree/master/mongodb


### 常用场景1 实时数据采集处理（脚本采用3.0的引擎）

> 采集网络获取数据.
>
> 存放到内存或者硬盘；硬盘顺序读写，确保高效；
>
> ## 日志输出到mongodb

数据采集-运行示例
---------------------
### 构造镜像包
> 进入到当前目录
> ## fig build
### 运行
> 进入到当前目录
> ## fig up -d && fig ps
### 观察日志
> 初始化数据
>
> sh initdb.sh //****必须先完成初始化，否则mongsink 不能自动生成数据库。
> mongo 192.168.59.103:27018  rs.status() ;mongo 192.168.59.103:27019 rs.status() ; mongo 192.168.59.103:27017 sh.status()
>
> 生产数据
> telnet 192.168.59.103 44449
>
> 输入:{ "name": "cxh", "sex": "man" }
>
> fig logs flume1
>
> mongo 192.168.59.103:27017
> show collections
> db.events.find()
>
> ## END

压力测试-运行示例
---------------------
### 构造镜像包
> 进入到当前目录
> ## fig build
### 运行
> 进入到当前目录
> ## fig up -d && fig ps
### 观察日志
> 初始化数据
>
> sh initdb.sh //****必须先完成初始化，否则mongsink 不能自动生成数据库。
>
> 下载并且运行一下代码：https://github.com/supermy/gs-accessing-data-mongodb
> 监控mongodb的运行状态：mongostat -h 192.168.59.103 -p 27017
> 查看服务器状态：mongo 192.168.59.103:27017   db.serverStatus()   
> ## END


数据导入-运行示例
---------------------
>
>导入csv格式的数据  用户：--db  集合：--c  格式:--type
>
>--headerline 表示CSV格式的第一行为字段，如果不指定这个参数，则会将CSV格式第一行当数据导入到目标库。
>

* 同步数据: rsync -avz -e ssh root@192.168.*.*:/file/mymongodb/initdbi*.js .
* 初始化数据: sh initdb-*.*.sh
* shell环境: mongo 192.168.*.*:27017
* 导入数据脚本；转换数据格式为tsv；转换文档编码  -v --stopOnError
* time ls \
    | xargs iconv -f utf8 -t utf8 -c \
    | awk -F"|" 'BEGIN{OFS="\t";}{NF=NF;print $0}'  \
    | mongoimport  -h 192.168.*.*:27017 -d gndata -c tellog --type tsv -f f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,19,f20,f21,f22,f23,f24,f25,f26,f27,f28,f29,f30,f31,f32,f33,f34,f35,f36

*
time ls gndata/1.txt \
    | xargs iconv -f utf8 -t utf8 -c \
    | awk -F"|" 'BEGIN{OFS="\t";}{NF=NF;print $0}'  \
    |  mongoimport -h 192.168.59.103:27017 -d gndata -c tellog --type tsv -f f1,f2,f3,f4


,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,19,f20,f21,f22,f23,f24,f25,f26,f27,f28,f29,f30,f31,f32,f33,f34,f35,f36

##存储优化
> docker容器默认的空间是10G,docker -d --storage-opt dm.basesize=20G,修改后需要重启docker。
启动docker服务时，加上–g参数指定docker工作目录，镜像等文件会存到这。

* --storage-opt dm.metadatadev=/dev/dm-26
* --storage-opt dm.datadev=/dev/dm-27
* --storage-opt dm.fs=xfs

##性能监控
mongostat -h 192.168.6.53:27017 1
> ## 数据导入
https://github.com/supermy/mytools/tree/master/mymongodb
http://t.cn/RwfruoO