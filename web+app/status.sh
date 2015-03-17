echo 'mysql status......'
docker ps -a|grep entrypoint.sh|awk '{print $1}'|xargs docker top
echo 'tomcat status......'
docker ps -a|grep tomcat|awk '{print $1}'|xargs docker top
echo 'nginx status......'
docker ps -a|grep nginx|awk '{print $1}'|xargs docker top
echo 'memcached status......'
docker ps -a|grep memcached|awk '{print $1}'|xargs docker top
