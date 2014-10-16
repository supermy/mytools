#MongoDB Sharded Cluster

## Create Docker Images

```
sudo docker build -t dev24/mongodb mongod
sudo docker build -t dev24/mongo   mongos
```

## Create a Replica Set

```
sudo docker run -name rs1_srv1 -P -d dev24/mongodb --noprealloc --smallfiles --replSet rs1
sudo docker run -name rs1_srv2 -P -d dev24/mongodb --noprealloc --smallfiles --replSet rs1
sudo docker run -name rs1_srv3 -P -d dev24/mongodb --noprealloc --smallfiles --replSet rs1
```

Create a second replica set as the basis for the sharded cluster created below.

```
sudo docker run -name rs2_srv1 -P -d dev24/mongodb --noprealloc --smallfiles --replSet rs2
sudo docker run -name rs2_srv2 -P -d dev24/mongodb --noprealloc --smallfiles --replSet rs2
sudo docker run -name rs2_srv3 -P -d dev24/mongodb --noprealloc --smallfiles --replSet rs2
```

Create some Config Servers

```
sudo docker run -name cfg1 -P -d dev24/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port 27017
sudo docker run -name cfg2 -P -d dev24/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port 27017
sudo docker run -name cfg3 -P -d dev24/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port 27017
```

Create a Mongo Router

```
sudo docker run -name mongos1 -P -d dev24/mongos --configdb <IP_of_container_cfg1>:27017,<IP_of_container_cfg2>:27017,<IP_of_container_cfg3>:27017 --port 27017
```

## Initialize Replica Sets

Get IPs and port bindings of all Docker containers

```
sudo docker inspect rs1_srv1
sudo docker inspect rs1_srv2
...
```

### Initialize Replica Set 1

Connect to rs1_srv1 (you need the local port bound for 27017/tcp)

```
mongo --port <port>

rs.initiate()
rs.add("<IP_of_rs1_srv2>:27017")
rs.add("<IP_of_rs1_srv3>:27017")
rs.status()
```

Fix hostname of primary.

```
cfg = rs.conf()
cfg.members[0].host = "<IP_of_rs1_srv1>:27017"
rs.reconfig(cfg)
rs.status()
```

### Initialize Replica Set 2

Connect to rs2_srv1 (you need the local port bound for 27017/tcp)

```
mongo --port <port>

rs.initiate()
rs.add("<IP_of_rs2_srv2>:27017")
rs.add("<IP_of_rs2_srv3>:27017")
rs.status()
```

Fix hostname of primary.

```
cfg = rs.conf()
cfg.members[0].host = "<IP_of_rs2_srv1>:27017"
rs.reconfig(cfg)
rs.status()
```

## Initialize Shard

Connect to mongos1 (you need the local port bound for 27017/tcp)

```
mongo --port <port>

sh.addShard("rs1/<IP_of_rs1_srv1>:27017")
sh.addShard("rs2/<IP_of_rs2_srv1>:27017")
sh.status()
```

