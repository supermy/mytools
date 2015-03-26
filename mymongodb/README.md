#2015-03-26
升级到mongodb3.0.1；
存储外置；
使用start.sh启动

docker build -t jamesmo/mongo:3.0.1 - <Dockerfile-3.0.1
docker build -t yourname/imagename:yourtagname - < yourdockerfilename

#2015-01-13
https://github.com/supermy/mytools/tree/master/mymongodb
#fig+docker一键启动mongodb副本集
fig up -d
#shell+js一键初始化复制集
sh initdb.sh