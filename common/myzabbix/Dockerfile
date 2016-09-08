#修改默认配置,增加中文语言支持
FROM zabbix/zabbix-3.0:latest

MAINTAINER JamesMo

RUN sed -in "s/zh_CN).*false/zh_CN'),     'display' => true/g" /usr/local/src/zabbix/frontends/php/include/locales.inc.php