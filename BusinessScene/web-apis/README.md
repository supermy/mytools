基于api的快速框架
=========================


[TOC]

#应用场景
rails 的架构风格
api 提供json数据，使用模本引擎解析；
lua-resty-template 模板引擎，使用layout及组件进行页面组装；
lua 进行A/B测试配置；


##变更日志
###2016-09-10
*   优化整理web-apis架构


##主要功能


###配置文件 conf/nginx
####配置文件 conf/nginx/nginx.conf
-   全局的nginx配置文件
-   如果没有特殊需求，可依据模板变动并且启用
-   主要是通过include整合其他文件
#### conf/nginx/http.d
-   http 通用设置：1-http-ext-common.conf
-   redis通用设置：2-upstream-common.conf
-   lua配置文件，waf配置；lua缓存是否生效;配置文件字典；常用lualib；lua global 函数与变量;lua worker心跳：http-lua.conf
#### conf/nginx/server.d
-   http 访问路径配置：
-   route-form.conf rails风格引擎；
    ```
    http://127.0.0.1/formroutequery?html=route-json&query=users&query=avatar&page=0&size=3
    html 输出模板,使用lua-resty-template模板引擎，根据json value组装输出结果,格式是json/text/html；
    query 查询api;在query.d/0-config-db-query.json在定义查询api；支持spring-boot api 与 elastcisearch api ;支持多个query查询，参数在多个query api中可复用；
    
    ```
-   lua-proxy-extjs.conf  增删改api提交的反向代理；
-   lua-template.conf 模板引擎的配置
###配置文件 conf/lua.app
lua 应用目录
####配置文件 conf/lua.app/lua.d
-   lua 引擎文件
-   全局变量、全局函数 0-global-init.lua
-   心跳  0-init_worker.lua
-   反向代理路径配置 0-init_worker.lua
-   elasticsearch查询filter支持 4-extjs4.lua
-   输出内容加工 6-body-filter-extjs.lua
-   rails风格引擎 route-form.lua
####配置文件 conf/lua.app/query.d
-   API查询配置文件 0-config-db-query.json
-   权限配置文件  0-config-db-acl.json
####配置文件 conf/lua.app/third.lua.lib
-   cjson lua 库
-   httpc   lua 库
-   template lua 库
####配置文件 conf/lua.app/templates
-   布局文件目录 layouts
-   管理平台模板文件 manage
-   前端暂时页面模板文件 web
####配置文件 logs
-   日志文件目录
####配置文件 www
-   管理平台资源文件
-   展示平台资源文件
-   上传文件目录


###运行环境 fig.yml
####web
-   采用alpine for waf 镜像，尺寸小，时区与中文支持环境支持；
-   设置80端口提供访问，如果本机已被占用，可更改为别的端口；
-   绑定运行环境目录volumes_from，使得运行环境可配置；
-   链接app 与 redis , 使得配置文件对于app与redis的引用营销；
-   www/manage/js/plugins/datatables/editor 需要自行下载
####dataWeb
-   进行日志路径配置链接到本地路径，使得容器日志可查看，方便调试；
-   进行运行参数文件链接到本地文件，使得同一个镜像文件可以应用于不同的业务应用；
####app
-   spring-boot 单个实例；可配置为集群再使用；
####redis
-   使用ap-redis,尺寸较小；
-   提供tomcat session 共享存储；
-   也可提供nginx 共享存储；
-   业务如果数据量大，建议单独建立redis镜像集群；



##测试
###测试
[启动rest-api]((https://github.com/supermy/rest-api))，为应用提供[api数据源](http://127.0.0.1:9006/form/rest/user)；
进入到fig.xml 目录执行以下命令进行测试,使用浏览器访问；

    fig up -d && fig ps
    编排api http://127.0.0.1/formroutequery?html=route-json&query=users&query=avatar&page=0&size=3
    管理页面 http://127.0.0.1/formroutequery?html=manage/my-users&query=users&query=avatar&page=0&size=3
    展示页面 http://127.0.0.1/formroutequery?html=web/web-index&query=users&page=0&size=3
    fig stop && fig rm -v --force
    