#修改默认配置,增加中文语言支持
#docker build -t supermy/ap-zabbix zabbix
#FROM zabbix/zabbix-server-mysql:alpine-latest
FROM zabbix/zabbix-web-nginx-mysql:alpine-latest

#docker pull zabbix/zabbix-server-mysql

MAINTAINER JamesMo

#RUN sed -in "s/zh_CN).*false/zh_CN'),     'display' => true/g" /usr/local/src/zabbix/frontends/php/include/locales.inc.php