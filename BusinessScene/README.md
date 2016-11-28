Docker 的常见应用场景
=========================


[TOC]

#应用场景
最新alipine镜像包项目
进入https://hub.docker.com/search/?isAutomated=0&isOfficial=0&page=1&pullCount=0&q=supermy%2Fap-&starCount0

最新alpine业务场景项目
进入https://github.com/supermy?tab=repositories  搜索 bs-

##变更日志
###2016-09-10
*   业务场景整理
###2016-09-12
*   spring-boot-cluster 完成
*   tomcat-cluster 完成
*   waf-proxy  完成
*   web-apis 完成


##主要功能
-   所有镜像可配置
###spring-boot-cluster
-   docker  镜像构造需要的mysql and db环境；
-   docker 镜像supermy/ap-jre构造spring-boot运行所需的java环境；
-   spring-boot 自身解决集群session
[启动rest-api]((https://github.com/supermy/rest-api))，为应用提供[api数据源](http://127.0.0.1:9006/form/rest/user)；

###tomcat-cluster
-   docker镜像提供 集群应用发布环境，reids 、 mysql and db环境；
-   提供mysql数据初始化环境；

###waf-prxoy 
-   nginx 与 tomcat集群整合示例

###web-apis
-   提供rail风格的开发框架；
-   前端是模板引擎+json进行页面渲染，可以通过layout布局与组件复用；
-   后端是api提供json数据格式，api可编排；目前支持spring-boot and elasticsearch api;
-   前端页面按秒开的思路迭代改进；

###waf
-   软防火墙，网络安全增强，抵御常见网络攻击；


##测试
###测试
进入到fig.xml 目录执行以下命令进行测试；

    fig up -d && fig ps
    
    
    fig stop && fig rm -v --force
    