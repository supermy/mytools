# 通用工具构造
cd common
sh build.sh
cd ..

#分布式系统build
cd /Users/moyong/project/env-myopensource/mytools/web+app/mynginx
fig stop && fig rm --force -v && fig build

cd /Users/moyong/project/env-myopensource/mytools/web+app/mytomcat
fig stop && fig rm --force -v && fig build

cd /Users/moyong/project/env-myopensource/mytools/web+app
fig stop && fig rm --force -v && fig build


#云平台build
#cd /Users/moyong/project/env-myopensource/mytools/mycloud
#fig stop && fig rm --force -v && fig build

#cd /Users/moyong/project/env-myopensource/mytools/mycloud-hadoop
#fig stop && fig rm --force -v && fig build

#cd /Users/moyong/project/env-myopensource/mytools/mycloud-hbase
#fig stop && fig rm --force -v && fig build

#cd /Users/moyong/project/env-myopensource/mytools/mycloud-zookeeper
#fig stop && fig rm --force -v && fig build

#cd /Users/moyong/project/env-myopensource/mytools/mytomcat
#fig stop && fig rm --force -v && fig build
