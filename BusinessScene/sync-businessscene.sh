#!/usr/bin/env bash
# 通用工具构造
# 分拆到不同的项目，自动同步到版本库；进行自动镜像构建
cd /Users/moyong/project/env-myopensource/3-tools/mytools/BusinessScene
rsync -avz  base/*  /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/tomcat-cluster/
cd /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/tomcat-cluster/
sh /Users/moyong/project/env-myopensource/3-tools/docker/BusinessScene/addgit.sh tomcat-cluster 初始化项目

