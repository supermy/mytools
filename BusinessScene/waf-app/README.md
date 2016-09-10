waf-app
=========================


[TOC]

#应用场景
提供tomcat 集群的基础；提供统一的应用发布环境；能快捷发布应用。

##变更日志
###2016-09-09
*   初始化项目
*   alpine for redis 镜像支持;session 支持；
*   mysql 中文支持，无乱码。
*   alpine for tomcat 镜像支持；中文支持；


##主要功能
-   镜像包支持：tomcat 使用redis 进行session 共享
-   app 目录下部署应用；logs 目录下查看日志；
-   启动集群并且查看各节点服务状况：
###镜像tomcat
- tomcat 配置session 存储到redis；
- 指定每个节点的端口，节点端口不能重复；
- 配置tomcat 控制台的密码，TOMCAT_PASS: admin；
- 指定应用部署目录：volumes_from:
- 进入容器查看环境：docker exec -it 71e14297f481 bash
- alpine for tomcat-cluster 中文支持
###镜像redis
- 存储tomcat session;
- 查看现有的session:redis-cli:keys *；
- 查看某条session:get sessionkey；
###镜像mysql
- 存储业务数据
-   指定root 用户密码；初始化一个业务用户并且指定密码；
-   通过dbinit 初始化数据库数据；初始化数据中文乱码......
###镜像data
-   指定日志目录，如果部署多个应用，应该指定不同的日志目录，方便调试；
-   指定应用程序部署目录；
-   指定配置文件目录；

##测试
###token 测试
进入到fig.xml 目录执行以下命令进行测试；同一个浏览器访问两个不同的地址，返回的token 值应该一样。

    fig up -d && fig ps
    
    http://127.0.0.1:8081/myweb/token.jsp
    
    http://127.0.0.1:8082/myweb/token.jsp
    
    fig stop && fig rm -v --force
    