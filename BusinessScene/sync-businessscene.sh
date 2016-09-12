#!/usr/bin/env bash
# 通用工具构造
# 分拆到不同的项目，自动同步到版本库；进行自动镜像构建
cd /Users/moyong/project/env-myopensource/3-tools/mytools/BusinessScene
rsync -avz  tomcat-cluster/*  /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/bs-tomcat-cluster/
cd /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/bs-tomcat-cluster/
sh /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/addgit.sh bs-tomcat-cluster 初始化项目

cd /Users/moyong/project/env-myopensource/3-tools/mytools/BusinessScene
rsync -avz  spring-boot-cluster/*  /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/bs-spring-boot-cluster/
cd /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/bs-spring-boot-cluster/
sh /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/addgit.sh bs-spring-boot-cluster 初始化项目


cd /Users/moyong/project/env-myopensource/3-tools/mytools/BusinessScene
rsync -avz waf-proxy/*  /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/bs-waf-proxy/
cd /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/bs-waf-proxy/
sh /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/addgit.sh bs-waf-proxy 初始化项目


cd /Users/moyong/project/env-myopensource/3-tools/mytools/BusinessScene
rsync -avz --exclude www/manage/assets --exclude www/manage/js/plugins/datatables/editor  web-apis/*  /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/bs-web-apis/
cd /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/bs-web-apis/
sh /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/addgit.sh bs-web-apis 初始化项目
