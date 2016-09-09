云之基石
====================

##介绍
---------------------
###构造基础镜像包
- 一是准备需要的中文环境；
- 二是准备离线镜像包，避免每次构造的网络开销；
- 三是保持一段时间的稳定版本；

###有两个版本
- 一个是build 版本，包含编译需要的基础环境；
- 一个是通用版本，包含需要的环境及时区常用的网络命令；
###todo
-时区

###命令
```
> docker build -t supermy/alpine base
> docker run --rm -ti  supermy/alpine:latest
> docker build -t supermy/alpine:build base/build
> docker run --rm -ti  supermy/alpine:build
```