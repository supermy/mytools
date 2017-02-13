#!/usr/bin/env bash
#csv 要删除分隔符之间的空格否则影响关系建立，第一行字段之前的空格也要删除
https://neo4j.com/developer/guide-import-csv/
$NEO4J_HOME/bin/neo4j-import --into $NEO4J_HOME/data/databases/graph.db --nodes:Person csv/person_node.csv \
    --nodes:Movie csv/movie_node.csv --nodes:Genre csv/genre_node.csv --nodes:Keyword csv/keyword_node.csv \
    --relationships:ACTED_IN csv/acted_in_rels.csv --relationships:DIRECTED csv/directed_rels.csv \
    --relationships:HAS_GENRE csv/has_genre_rels.csv --relationships:HAS_KEYWORD csv/has_keyword_rels.csv \
    --relationships:PRODUCED csv/produced_rels.csv --relationships:WRITER_OF csv/writer_of_rels.csv --delimiter ";" \
    --array-delimiter "|" \
    --id-type INTEGER


$NEO/bin/neo4j-import --into $DB --id-type $IDTYPE --delimiter TAB --quote Ö \
 --nodes:PROFILES profiles_header.txt,soc-pokec-profiles_no_null_sorted.txt.gz \
 --relationships:RELATION relationships_header.txt,soc-pokec-relationships.txt.gz


https://neo4j.com/developer/guide-import-csv/
http://neo4j.com/docs/operations-manual/current/tutorial/import-tool/

docker exec -it neo4j_db_1 bash -c "more /var/lib/neo4j/import.report"
docker exec -it neo4j_db_1 bash -c "/var/lib/neo4j/bin/neo4j-admin import"

docker exec -it neo4j_db_1 bash -c "/var/lib/neo4j/bin/neo4j-admin import \
             --mode=csv --database=rabc.db --id-type=STRING \
             --nodes:User=/csvs/users.csv \
             --nodes:Role=/csvs/roles.csv \
             --nodes:Auth=/csvs/auths.csv \
             --nodes:Resource=/csvs/resources_head.csv,/csvs/resources.csv \
             --nodes:Group=/csvs/group_head.csv,/csvs/groups.csv \
             --nodes:Module=/csvs/modules.csv \
             --relationships:UR=/csvs/user-roles.csv \
             --relationships:RA=/csvs/role-auths.csv \
             --relationships:GU=/csvs/group-users-head.csv,/csvs/group-users.csv \
             --relationships:UG=/csvs/group-users-ug-head.csv,/csvs/group-users.csv \
             --relationships:GR=/csvs/group-roles.csv \
             --relationships:ARES=/csvs/auth-resources.csv \
             --relationships:PCRES=/csvs/resourcespc_head.csv,/csvs/resources.csv \
             --relationships:PCGROUP=/csvs/grouppc_head.csv,/csvs/groups.csv"

#FOREACH 示例
MATCH (r:Resource)
WITH COLLECT([r]) AS its
FOREACH (it IN its |
     SET (it[0]).testprop="89292" )

#FOREACH 示例 error
MATCH (r:Resource)
WITH COLLECT([r]) AS its
FOREACH (it IN its |
    MATCH (child:Resource {module: it[0].module})
    MATCH (parent:Resource {module: it[0].pid})
    MERGE (child)-[:REPORTS_TO]->(parent))

#UNWIND 示例
MATCH (r:Resource)
WITH COLLECT([r]) AS its
UNWIND its AS it
    MATCH (child:Resource {module: it[0].module})
    MATCH (parent:Resource {module: it[0].pid})
    MERGE (child)-[:REPORTS_TO]->(parent)


WITH [{name: "Event 1", timetree: {day: 1, month: 1, year: 2014}},
      {name: "Event 2", timetree: {day: 2, month: 1, year: 2014}}] AS events
FOREACH (event IN events |
  CREATE (e:Event {name: event.name})
  MERGE (year:Year {year: event.timetree.year })
  MERGE (year)-[:HAS_MONTH]->(month {month: event.timetree.month })
  MERGE (month)-[:HAS_DAY]->(day {day: event.timetree.day })
  CREATE (e)-[:HAPPENED_ON]->(day))

WITH [{name: "Event 1", timetree: {day: 1, month: 1, year: 2014}},
      {name: "Event 2", timetree: {day: 2, month: 1, year: 2014}}] AS events
UNWIND events AS event
CREATE (e:Event {name: event.name})
WITH e, event.timetree AS timetree
MATCH (year:Year {year: timetree.year }),
      (year)-[:HAS_MONTH]->(month {month: timetree.month }),
      (month)-[:HAS_DAY]->(day {day: timetree.day })
CREATE (e)-[:HAPPENED_ON]->(day)




//用户具备的资源：（todo:组织机构的父子查询）
MATCH (u:User)-[:UR]-(role:Role)-[:RA]-(auth:Auth)-[:ARES]-(res:Resource)
RETURN  u.namecn,res.url,res.name
UNION
//用户所在的组具备的权限：
MATCH (u:User)-[:GU]-(group:Group)-[:GR]-(role:Role)-[:RA]-(auth:Auth)-[:ARES]-(res:Resource)
RETURN  u.namecn,res.url,res.name

某个用户具备的资源；()
将资源组成树结构；（资源的父子查询）



MATCH (u:User{username:"alex3"})-[:UR]-(role:Role)
RETURN  role.name
UNION
MATCH (u:User{username:"alex3"})-[:GU]-(group)-[:GR]-(role:Role)
RETURN  role.name
UNION
//下属机构的角色 无限级别
MATCH (u:User{username:"alex3"})-[:GU]-(group1:Group)-[:PCGROUP*]->(group2:Group)-[:GR]-(role:Role)
RETURN  role.name


#用户角色 用户组织角色
MATCH (u:User)-[*]-(role:Role)
RETURN distinct  role.name

MATCH (u:User{username:"jamesmo"})-[*]-(role:Role)
RETURN distinct  role.name

MATCH (u:User{username:"jamesmo"})-[*]->(role:Role)
RETURN distinct  role.name


//用户增删改查crud
curl -v -H "Content-Type: application/json; charset=UTF-8; stream=true" -X POST \
        -u neo4j:123456 http://localhost:7474/db/data/cypher \
        -d '{"query":"CREATE (n:User { props } ) RETURN n",
            "params" : {
                "props" : {
                  "id" : "21",
                  "username" : "alex21",
                  "avatar_id" : 1,
                  "password" : "$2a$10$04TVADrR6/SPLBjsK0N30.Jf5fNjBugSACeGv1S69dZALR7lSov0y",
                  "namecn" : "李四",
                  "enabled" : "1",
                  "createDate" : "2016-12-24 22:42",
                  "updateDate" : "2016-12-24 22:42",
                  "createBy" : "system1",
                  "updateBy" : "system2"
                }}
             }'


curl -v -H "Content-Type: application/json; charset=UTF-8; stream=true" -X POST \
        -u neo4j:123456 http://localhost:7474/db/data/cypher \
        -d '{"query":"CREATE (n:Role { props } ) RETURN n",
            "params" : {
                "props" : {
                  "id" : "6",
                  "role_id" : "ROLE_APP",
                  "name" : "ROLE_APP应用API",
                  "remark" : "测试数据",
                  "enabled" : "1",
                  "createDate" : "2016-12-24 22:42",
                  "updateDate" : "2016-12-24 22:42",
                  "createBy" : "system1",
                  "updateBy" : "system2"
                }}
             }'
//建立用户与角色的关系
curl -v  -H "Content-Type: application/json; charset=UTF-8" -X POST \
    -u neo4j:123456 http://localhost:7474/db/data/node/311/relationships \
        -d '{
          "to" : "http://localhost:7474/db/data/node/312",
          "type" : “Role",
          "data" : {     "foo" : "bar"   }
        }'


curl -v  -H "Content-Type: application/json; charset=UTF-8" -X DELETE \
    -u neo4j:123456 http://localhost:7474/db/data/node/310







curl -v -H "Content-Type: application/json; charset=UTF-8; stream=true" -X POST \
        -u neo4j:123456 http://localhost:7474/db/data/cypher \
        -d '{"query" : "MATCH (x {name: {startName}})-[r]-(friend) WHERE friend.name = {name} RETURN TYPE(r)",
            "params" : {     "startName" : "I",     "name" : "you"   }
             }'

curl -v -H "Content-Type: application/json; charset=UTF-8; stream=true" -X POST \
        -u neo4j:123456 http://localhost:7474/db/data/cypher \
        -d '{
              "query" : "CREATE (n:Person { name : {name} }) RETURN n",
              "params" : {
                "name" : "Andres"
              }
            }'

curl -v -H "Content-Type: application/json; charset=UTF-8; stream=true" -X POST \
        -u neo4j:123456 http://localhost:7474/db/data/cypher \
        -d '
        {"query" : "UNWIND {props} AS properties CREATE (n:Person) SET n = properties RETURN n",
          "params" : {
            "props" : [ {
              "name" : "Andres",
              "position" : "Developer"
            }, {
              "name" : "Michael",
              "position" : "Developer"
            } ]
          }
        }'

curl -v -H "Content-Type: application/json; charset=UTF-8; stream=true" -X POST \
        -u neo4j:123456 http://localhost:7474/db/data/cypher \
        -d '{
              "query" : "CREATE (n:Person { name: \"this property is to be deleted\" } ) SET n = { props } RETURN n",
              "params" : {
                "props" : {
                  "position" : "Developer",
                  "firstName" : "Michael",
                  "awesome" : true,
                  "children" : 3
                }
              }
            }'

curl -v -H "Content-Type: application/json; charset=UTF-8; stream=true" -X POST \
        -u neo4j:123456 http://localhost:7474/db/data/cypher \
        -d '{
  "query" : "MATCH (x {name: \"I\"})-[r]->(n) RETURN type(r), n.name, n.age",
  "params" : { }
}'

curl -v -H "Content-Type: application/json; charset=UTF-8; stream=true" -X POST \
        -u neo4j:123456 http://localhost:7474/db/data/cypher \
        -d '{
  "query" : "MATCH (x:User) RETURN x",
  "params" : { }
}'

curl -v -H "Content-Type: application/json; charset=UTF-8; stream=true" -X POST \
        -u neo4j:123456 http://localhost:7474/db/data/cypher \
        -d '{
  "query" : "MATCH (x:Resource{name: {name} }) RETURN x",
  "params" : {"name":"地区"}
}'


curl -H accept:application/json -H content-type:application/json \
  -d '{"statements":[{
        "statement":"MATCH (x:Resource{name: {name} }) RETURN x",
         "parameters": {"name":"地区"}
    }]}' \
  -u neo4j:123456  http://localhost:7474/db/data/transaction/commit


curl -H accept:application/json -H content-type:application/json \
     -d '{"statements":[{"statement":"MATCH (x:Resource) RETURN x' \
     -u neo4j:123456  http://localhost:7474/db/data/transaction/commit \
     | jq -r '(.results[0]) | .columns,.data[].row | @csv'

curl -v -H "Content-Type: application/json; charset=UTF-8; stream=true" -X POST \
        -u neo4j:123456 http://localhost:7474/db/data/transaction/commit \
        -d '{
  "statements": [
    {
      "statement": "UNWIND { events } AS event MERGE (y:Year { year:event.year }) MERGE (y)<-[:IN]-(e:Event { id:event.id }) RETURN e.id AS x ORDER BY x",
      "parameters":{
                   "events" : [ {
                        "year" : 2014,
                        "id" : 1
                      }, {
                        "year" : 2014,
                        "id" : 2
                      } ]
                    }
            }
      ]
}'