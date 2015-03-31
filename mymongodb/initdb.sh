#所有的服务器要通过IP地址进行通讯
#mac sed修改强制要求备份

#初始化复制集1
cp -f initdb.js initdbi-1.js
docker inspect  mymongodb_rs11_1| jsawk -a 'return this[0].NetworkSettings.IPAddress'|awk '{print $1}'|xargs -I@ sed -i bak 's/rs11/@/g' initdbi-1.js
docker inspect  mymongodb_rs12_1| jsawk -a 'return this[0].NetworkSettings.IPAddress'|awk '{print $1}'|xargs -I@ sed -i bak 's/rs12/@/g' initdbi-1.js
docker inspect  mymongodb_rs13_1| jsawk -a 'return this[0].NetworkSettings.IPAddress'|awk '{print $1}'|xargs -I@ sed -i bak 's/rs13/@/g' initdbi-1.js
cat initdbi-1.js
mongo  192.168.59.103:27018/test --quiet initdbi-1.js
sleep 3

#初始化复制集2
cp -f initdb.js initdbi-2.js
docker inspect  mymongodb_rs21_1| jsawk -a 'return this[0].NetworkSettings.IPAddress'|awk '{print $1}'|xargs -I@ sed -i bak 's/rs11/@/g' initdbi-2.js
docker inspect  mymongodb_rs22_1| jsawk -a 'return this[0].NetworkSettings.IPAddress'|awk '{print $1}'|xargs -I@ sed -i bak 's/rs12/@/g' initdbi-2.js
docker inspect  mymongodb_rs23_1| jsawk -a 'return this[0].NetworkSettings.IPAddress'|awk '{print $1}'|xargs -I@ sed -i bak 's/rs13/@/g' initdbi-2.js
#更换复制集名称
sed -i bak 's/rs1/rs2/g' initdbi-2.js
cat initdbi-2.js
mongo  192.168.59.103:27019/test --quiet initdbi-2.js
sleep 3

## 初始化Shard
cp -f initdbs.js initdbi.js
docker inspect  mymongodb_rs11_1| jsawk -a 'return this[0].NetworkSettings.IPAddress'|awk '{print $1}'|xargs -I@ sed -i bak 's/rs11/@/g' initdbi.js
docker inspect  mymongodb_rs21_1| jsawk -a 'return this[0].NetworkSettings.IPAddress'|awk '{print $1}'|xargs -I@ sed -i bak 's/rs21/@/g' initdbi.js
cat initdbi.js
mongo  192.168.59.103:27017/admin --quiet initdbi.js

##