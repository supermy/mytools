waf+proxy 防火墙和常见的反向代理服务
=========================


[TOC]

#应用场景
通常用于tomcat集群的前置；进行负载均衡；进行安全防护与增强
可配置新增的http服务；
可配置新增的location服务；在location中配置反向代理服务


##变更日志
###2016-09-10
*   完成waf+tomcat集群的集群与测试


##主要功能


###配置文件 conf/nginx
####配置文件 conf/nginx/nginx.conf
-   全局的nginx配置文件
-   如果没有特殊需求，可依据模板变动并且启用
-   主要是通过include整合其他文件
#### conf/nginx/http.d
-   http 通用设置：1-http-ext-common.conf
-   redis通用设置：2-upstream-common.conf
-   tomcat 负载均衡配置：2-upstream-java.conf
-   waf 防火墙配置：http-waf.conf
#### conf/nginx/server.d
-   http 访问路径配置：

###运行环境 fig.yml
####web
-   采用alpine for waf 镜像，尺寸小，时区与中文支持环境支持；
-   设置80端口提供访问，如果本机已被占用，可更改为别的端口；
-   绑定运行环境目录volumes_from，使得运行环境可配置；
-   链接app 与 redis , 使得配置文件对于app与redis的引用营销；
####dataWeb
-   进行日志路径配置链接到本地路径，使得容器日志可查看，方便调试；
-   进行运行参数文件链接到本地文件，使得同一个镜像文件可以应用于不同的业务应用；
####app
-   配置tomcat，使用定制的ap-tomcat-cluster镜像包，中文支持，尺寸较小,支持redis共享session;
-   可配置tomcat控制台的口令；
-   可配置暴露端口，便于调试；
-   webapps目录可配置，方便发布tomcat;
-   日志可配置，方便进行日志查看；
-   链接到mysql and redis ,为应用提供基础设施；还可以配置初始化数据；
####dataApp
-   配置tomcat的应用发布目录webapps；
-   配置tomcat容器日志目录；
####redis
-   使用ap-redis,尺寸较小；
-   提供tomcat session 共享存储；
-   也可提供nginx 共享存储；
-   业务如果数据量大，建议单独建立redis镜像集群；
####db
-   可以通过配置建立root账户与密码；建立普通账户与密码；
-   可配置开放端口，提供外部访问；
####dbinit
-   将固化的数据进行初始化



##测试
###测试
进入到fig.xml 目录执行以下命令进行测试,使用浏览器访问，三次访问得到的token应该一致；

    fig up -d && fig ps
    http://127.0.0.1/myweb/token.jsp
    http://127.0.0.1:8081/myweb/token.jsp
    http://127.0.0.1:8082/myweb/token.jsp
    fig stop && fig rm -v --force
    