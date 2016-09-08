2016-04-22
    cd /Users/moyong/project/env-myopensource/3-tools/mytools/common/myzabbix
    docker build -t supermy/myzabbix:latest .

    fig stop && fig rm -v --force && fig up -d && fig ps

    docker exec -it myzabbix_zabbix_1 bash

2016-04-14
     zabbixdb_1 | InnoDB: http://dev.mysql.com/doc/refman/5.6/en/error-creating-innodb.html
     zabbixdb_1 | 2016-04-14 06:41:42 1 [ERROR] Plugin 'InnoDB' init function returned error.
     zabbixdb_1 | 2016-04-14 06:41:42 1 [ERROR] Plugin 'InnoDB' registration as a STORAGE ENGINE failed.
     zabbixdb_1 | 2016-04-14 06:41:42 1 [ERROR] Unknown/unsupported storage engine: InnoDB
     zabbixdb_1 | 2016-04-14 06:41:42 1 [ERROR] Aborting