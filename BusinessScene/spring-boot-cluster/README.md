tomcat 集群
=========================


[TOC]

#应用场景
[spring-boot 代码支持redis 集群](https://github.com/supermy/rest-api)；提供统一的mysql/redis应用发布环境；能快捷发布应用。

##变更日志
###2016-09-09
*   spring-boot-redis 整合


##主要功能
-   镜像包支持：tomcat 使用redis 进行session 共享
-   app 目录下部署应用；logs 目录下查看日志；
-   启动集群并且查看各节点服务状况：
###镜像redis
- 存储tomcat session;
- 查看现有的session:redis-cli:keys *；
- 查看某条session:get sessionkey；
###镜像mysql
- 存储业务数据
-   指定root 用户密码；初始化一个业务用户并且指定密码；
-   通过dbinit 初始化数据库数据；初始化数据中文乱码......


##测试
###token 测试
进入到fig.xml 目录执行以下命令进行测试；同一个浏览器访问两个不同的地址，返回的token 值应该一样。

    fig up -d && fig ps
    
    http://127.0.0.1:9006/form/rest/
    
    http://127.0.0.1:9008/form/rest/
    
    fig stop && fig rm -v --force
    