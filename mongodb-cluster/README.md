#MongoDB Sharded Cluster

## Create Docker Images

```
docker build -t mydev/mongodb mongod
docker build -t mydev/mongos   mongos
```

##集群的复制集1

docker run   -h plone --name="plone" --net=none  -P -d mydev/mongodb --noprealloc --smallfiles

```
docker run --name rs1_srv1 -P -d mydev/mongodb --noprealloc --smallfiles --replSet rs1 --rest --httpinterface
docker run --name rs1_srv2 -P -d mydev/mongodb --noprealloc --smallfiles --replSet rs1 --rest --httpinterface
docker run --name rs1_srv3 -P -d mydev/mongodb --noprealloc --smallfiles --replSet rs1 --rest --httpinterface
```

##集群的复制集2
```
docker run --name rs2_srv1 -P -d mydev/mongodb --noprealloc --smallfiles --replSet rs2 --rest --httpinterface
docker run --name rs2_srv2 -P -d mydev/mongodb --noprealloc --smallfiles --replSet rs2 --rest --httpinterface
docker run --name rs2_srv3 -P -d mydev/mongodb --noprealloc --smallfiles --replSet rs2 --rest --httpinterface
```

##配置文件集群
```
docker run --name cfg1 -P -d mydev/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port 27017
docker run --name cfg2 -P -d mydev/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port 27017
docker run --name cfg3 -P -d mydev/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port 27017
```

##创建一个路由


```
docker run --name mongos1 -P -d mydev/mongos --configdb 172.17.0.8:27017,172.17.0.9:27017,172.17.0.10:27017 --port 27017
```

## 初始化复制集

获取所有容器的IP地址和端口

```
sudo docker inspect rs1_srv1
sudo docker inspect rs1_srv2
...
```

docker>sudo vi /etc/hosts


### 初始化复制集1

Connect to rs1_srv1 (you need the local port bound for 27017/tcp)

```
mongo --port <port>

rs.initiate()
rs.add("172.17.0.3:27017")
rs.add("172.17.0.4:27017")
rs.status()
```

Fix hostname of primary. 

```
cfg = rs.conf()
cfg.members[0].host = "172.17.0.2:27017"
rs.reconfig(cfg)
rs.status()
```

### 初始化复制集2

Connect to rs2_srv1 (you need the local port bound for 27017/tcp)

```
mongo --port <port>

rs.initiate()
rs.add("172.17.0.6:27017")
rs.add("172.17.0.7:27017")
rs.status()
```

Fix hostname of primary.

```
cfg = rs.conf()
cfg.members[0].host = "172.17.0.5:27017"
rs.reconfig(cfg)
rs.status()
```

## 初始化Shard

Connect to mongos1 (you need the local port bound for 27017/tcp)

```
mongo --port <port>

sh.addShard("rs1/<IP_of_rs1_srv1>:27017")
sh.addShard("rs2/<IP_of_rs2_srv1>:27017")
sh.status()
```

#常用命令
ssh -L 27019:127.0.0.1:49153 -L 27018:127.0.0.1:49156

docker inspect $(docker ps -a -q)|grep Address



#常用命令
sudo su

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

docker run --name rs1_srv1 -P -d mydev/mongodb --noprealloc --smallfiles --replSet rs1 --rest --httpinterface
docker run --name rs1_srv2 -P -d mydev/mongodb --noprealloc --smallfiles --replSet rs1 --rest --httpinterface
docker run --name rs1_srv3 -P -d mydev/mongodb --noprealloc --smallfiles --replSet rs1 --rest --httpinterface
docker run --name rs2_srv1 -P -d mydev/mongodb --noprealloc --smallfiles --replSet rs2 --rest --httpinterface
docker run --name rs2_srv2 -P -d mydev/mongodb --noprealloc --smallfiles --replSet rs2 --rest --httpinterface
docker run --name rs2_srv3 -P -d mydev/mongodb --noprealloc --smallfiles --replSet rs2 --rest --httpinterface
docker run --name cfg1 -P -d mydev/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port 27017
docker run --name cfg2 -P -d mydev/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port 27017
docker run --name cfg3 -P -d mydev/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port 27017
docker inspect $(docker ps -a -q)|grep Address

docker run --name mongos1 -P -d mydev/mongos --configdb 172.17.0.8:27017,172.17.0.9:27017,172.17.0.10:27017 --port 27017

docker logs $(docker ps -a -q)


想要删除untagged images，也就是那些id为<None>的image的话可以用
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
要删除全部image的话
docker rmi $(docker images -q)

# 删除所有未打标签的镜像.
alias dockercleani='docker rmi $(docker images -q -f dangling=true)'