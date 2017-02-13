#!/usr/bin/env bash
#csv 要删除分隔符之间的空格否则影响关系建立，第一行字段之前的空格也要删除
docker exec -i neo4j_db_1 bin/neo4j-shell < /Users/moyong/project/env-myopensource/3-tools/mytools/alpine/neo4j/csvs/import-load.cql