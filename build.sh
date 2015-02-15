cd /Users/moyong/project/env-myopensource/mytools/common/mydebian
fig stop && fig rm --force -v && fig build

cd /Users/moyong/project/env-myopensource/mytools/common/myjava7
fig stop && fig rm --force -v && fig build

cd /Users/moyong/project/env-myopensource/mytools/common/myjre7
fig stop && fig rm --force -v && fig build

#cd /Users/moyong/project/env-myopensource/mytools/common/myim
#fig stop && fig rm --force -v && fig build

cd /Users/moyong/project/env-myopensource/mytools/common/mykafka
fig stop && fig rm --force -v && fig build

cd /Users/moyong/project/env-myopensource/mytools/common/mysolr
fig stop && fig rm --force -v && fig build

cd /Users/moyong/project/env-myopensource/mytools/common/mystorm
fig stop && fig rm --force -v && fig build


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
