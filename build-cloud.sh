#云平台build
cd /Users/moyong/project/env-myopensource/mytools/mycloud
fig stop && fig rm --force -v && fig build

cd /Users/moyong/project/env-myopensource/mytools/mycloud-namenode
fig stop && fig rm --force -v && fig build

cd /Users/moyong/project/env-myopensource/mytools/mycloud-2namenode
fig stop && fig rm --force -v && fig build

cd /Users/moyong/project/env-myopensource/mytools/mycloud-datanode
fig stop && fig rm --force -v && fig build

cd /Users/moyong/project/env-myopensource/mytools/mycloud-resmng
fig stop && fig rm --force -v && fig build
