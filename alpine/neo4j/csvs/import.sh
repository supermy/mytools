#!/usr/bin/env bash

#数据初始化，使用专有的 Neo4j CSV 格式导入实体数据以及实体之间的关系；效率非常高效；以下导入的是 RBAC 的测试数据。
#其他参数 gzip groups.csv|  groups.csv.gz 支持压缩文件格式
#    --delimiter ";" \
#    --array-delimiter "|" \
#    --id-type INTEGER
# 参考
#       https://neo4j.com/developer/guide-import-csv/
#       http://neo4j.com/docs/operations-manual/current/tutorial/import-tool/

docker exec -it neo4j_db_1 bash -c "/var/lib/neo4j/bin/neo4j-admin import \
             --mode=csv --database=rabc.db --id-type=STRING \
             --nodes:User=/csvs/users.csv \
             --nodes:Role=/csvs/roles.csv \
             --nodes:Auth=/csvs/auths.csv \
             --nodes:Resource=/csvs/resources_head.csv,/csvs/resources.csv \
             --nodes:Group=/csvs/group_head.csv,/csvs/groups.csv \
             --nodes:Module=/csvs/modules.csv \
             --relationships:HASROLE=/csvs/user-roles.csv \
             --relationships:HASAUTH=/csvs/role-auths.csv \
             --relationships:HASUSER=/csvs/group-users-head.csv,/csvs/group-users.csv \
             --relationships:BELONGS=/csvs/group-users-ug-head.csv,/csvs/group-users.csv \
             --relationships:HASROLE=/csvs/group-roles.csv \
             --relationships:HASRES=/csvs/auth-resources.csv \
             --relationships:PARENTRES=/csvs/resourcespc_head.csv,/csvs/resources.csv \
             --relationships:CHILDRENGROUP=/csvs/grouppc_head.csv,/csvs/groups.csv"

#查看完成信息
docker exec -it neo4j_db_1 bash -c "more /var/lib/neo4j/import.report"





------------常用语法示例
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




WITH [{roles:"ROLE_USER,ROLE_WEBJS", username: "alex21", namecn : "李四211",createDate : "2016-03-09 22:42"},
      {roles:"ROLE_USER,ROLE_WEBJS",username: "alex22",namecn : "李四985",createDate : "2017-03-09 22:42"}]   AS events
UNWIND events AS user UNWIND split(user.roles,",")  AS  role   MATCH(r1:Role{role_id:role})   CREATE (r1)-[r2:RELTYPE3]->(r1)


----树 json 查询示例
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





--分页查询示例

//用户增删改查crud 分页查询 返回非数组 不能用error
curl -v -H "Content-Type: application/json; charset=UTF-8; stream=true" -X POST \
        -u neo4j:123456 http://localhost:7474/db/data/cypher \
        -d '{"query":" MATCH  (n: User)  WITH count(*) AS cnt  MATCH  (n:User)  WITH   n, cnt SKIP {start} LIMIT {pagesize}   RETURN   { totalCount: cnt, data:collect(n) } AS molecules",
            "params" : {"start":0,"pagesize":3}}'




//分页查询 WITH 针对结果执行查询 支持模糊查询
//in: start-开始记录 pagesize-页面记录数.
//out: totalCount-总记录数 data-json数组数据
curl -H accept:application/json -H content-type:application/json \
  -u neo4j:123456  http://localhost:7474/db/data/transaction/commit \
  -d '{"statements":[{
        "statement":"MATCH  (n:User) WHERE n.username=~{searchvalue} OR n.namecn=~{searchvalue}   WITH count(*) AS cnt  MATCH  (n:User)  WHERE n.username=~{searchvalue} OR n.namecn=~{searchvalue}  WITH   n, cnt SKIP (toInt({page})-1)*toInt({rows}) LIMIT toInt({rows})   RETURN   { total: cnt, rows:collect(n) } AS molecules",
         "parameters":{"page":1,"rows":3,"searchkey":"username","searchvalue":".*张.*"}
    }]}'

 --用户查询 带角色、带机构  用 lua-template 进行查询条件组装

    {% if isempty(org) and isempty(role) then %} 	MATCH (n:User) {% else %}	{% if not isempty(org) then %} 	MATCH (g:Group)-[r:GU]->(n:User) where g.group_id={org}  {% end %}	{% if not isempty(role) then %}  MATCH (r:Role)<-[ur:UR]-(n:User) where r.role_id={role}  {% end %}{% end %}{% if not isempty(searchvalue) then %}	{% if  isempty(org) and isempty(role) then %} WHERE   {% else %} and {% end %}   (n.username=~{searchvalue} OR n.namecn=~{searchvalue}) {% end %} WITH count(*) AS cnt	{% if isempty(org) and isempty(role) then %} 	MATCH (n:User) {% else %}		{% if not isempty(org) then %} 	MATCH (g:Group)-[r:GU]->(n:User) where g.group_id={org}  {% end %}		{% if not isempty(role) then %}  MATCH (r:Role)<-[ur:UR]-(n:User) where r.role_id={role}  {% end %}	{% end %}{% if not isempty(searchvalue) then %}	{% if isempty(org) and  isempty(role)  then %} WHERE   {% else %} and {% end %}   (n.username=~{searchvalue} OR n.namecn=~{searchvalue}) {% end %}WITH   n, cnt SKIP (toInt({page})-1)*toInt({rows}) LIMIT toInt({rows})   RETURN   { total: cnt, rows:collect(n) } AS molecules




 {% if isempty(org) and isempty(role) then %} 	MATCH (n:User) {% else %}
	{% if not isempty(org) then %} 	MATCH (g:Group)-[r:GU]->(n:User) where g.group_id={org}  {% end %}
	{% if not isempty(role) then %}  MATCH (r:Role)<-[ur:UR]-(n:User) where r.role_id={role}  {% end %}
{% end %}

{% if not isempty(searchvalue) then %}
	{% if  isempty(org) and isempty(role) then %} WHERE   {% else %} and {% end %}   (n.username=~{searchvalue} OR n.namecn=~{searchvalue}) {% end %}


WITH count(*) AS cnt
	{% if isempty(org) and isempty(role) then %} 	MATCH (n:User) {% else %}
		{% if not isempty(org) then %} 	MATCH (g:Group)-[r:GU]->(n:User) where g.group_id={org}  {% end %}
		{% if not isempty(role) then %}  MATCH (r:Role)<-[ur:UR]-(n:User) where r.role_id={role}  {% end %}
	{% end %}

{% if not isempty(searchvalue) then %}
	{% if isempty(org) and  isempty(role)  then %} WHERE   {% else %} and {% end %}   (n.username=~{searchvalue} OR n.namecn=~{searchvalue}) {% end %}

WITH   n, cnt SKIP (toInt({page})-1)*toInt({rows}) LIMIT toInt({rows})   RETURN   { total: cnt, rows:collect(n) } AS molecules



//EasyUI datagrid 单条语句处理增删改查.
--创建一批用户:
curl -H accept:application/json -H content-type:application/json \
  -u neo4j:123456  http://localhost:7474/db/data/transaction/commit \
  -d '{"statements":[{
        "statement":"UNWIND {props} AS line  CREATE (user:User {username:line.username}) SET user=line   MERGE (user)-[ur1:UR]->() delete ur1  FOREACH( roleline in  split(line.roles,\",\") |   MERGE(role:Role{role_id:roleline})  MERGE (user)-[ur:UR]->(role)  )  MERGE(group:Group{group_id:line.org})  MERGE (user)-[ug1:UG]->() delete ug1  MERGE (user)-[ug:UG]->(group)",
         "parameters":{
            "props" : [{
             "org":"web",
              "username" : "alex21",
              "namecn" : "李四21",
              "createDate" : "2016-12-24 22:42"
            }, {
              "org":"js",
              "roles":"ROLE_USER,ROLE_WEBJS",
              "username" : "alex22",
              "namecn" : "李四22",
              "createDate" : "2016-12-24 22:42"
            }]
          }
    }]}'



--更新一批用户节点信息,单个用户查找并且更新:
--处理组织机构关系 todo
--处理角色关系 todo UNWIND 可以使用 FOREACH ; FOREACH 后面不能跟 MATCH  group 不能为空
curl -H accept:application/json -H content-type:application/json \
  -u neo4j:123456  http://localhost:7474/db/data/transaction/commit \
  -d '{"statements":[{
        "statement":"UNWIND {props} AS line  MERGE (user:User {username:line.username}) SET user=line   MERGE (user)-[ur1:UR]->() delete ur1  FOREACH( roleline in  split(line.roles,\",\") |   MERGE(role:Role{role_id:roleline})  MERGE (user)-[ur:UR]->(role)  )  MERGE(group:Group{group_id:line.org})  MERGE (user)-[ug1:UG]->() delete ug1  MERGE (user)-[ug:UG]->(group)",
         "parameters":{
            "props" : [{
              "org":"web",
              "username" : "alex21",
              "namecn" : "李四211",
              "createDate" : "2016-03-09 22:42"
            }, {
              "org":"js",
              "roles":"ROLE_USER,ROLE_WEBJS",
              "username" : "alex22",
              "namecn" : "李四985",
              "createDate" : "2017-03-09 22:42"
            }]
          }
    }]}'





--删除一批用户节点和他所有的关系:
curl -H accept:application/json -H content-type:application/json \
  -u neo4j:123456  http://localhost:7474/db/data/transaction/commit \
  -d '{"statements":[{
        "statement":"UNWIND {props} AS properties MATCH (n:User{username:properties.username}) OPTIONAL MATCH (n)-[r]-() DELETE n,r",
         "parameters":{
            "props" : [ {
              "username" : "alex21",
              "namecn" : "李四21",
              "createDate" : "2016-12-24 22:42"
            }, {
              "username" : "alex22",
              "namecn" : "李四22",
              "createDate" : "2016-12-24 22:42"
            } ]
          }
    }]}'


--crud进行批次处理:
curl -H accept:application/json -H content-type:application/json \
  -u neo4j:123456  http://localhost:7474/db/data/transaction/commit \
  -d '{"statements":[{
        "statement":"WITH {p1:{inserted}} AS events   FOREACH (u1 IN events.p1 | CREATE (n:User) SET n = u1)  WITH {p2:{updated}} AS events  FOREACH (u2 IN events.p2 | MERGE (n:User {username:u2.username}) SET n.namecn = u2.namecn,  n.createDate = u2.createDate)   WITH {p3:{deleted}} AS events  UNWIND events.p3  AS u3  MATCH (n:User{username:u3.username}) OPTIONAL MATCH (n)-[r]-() DELETE n,r ",
         "parameters":{
            "inserted" : [ {
              "username" : "p1alex21",
              "namecn" : "李四21",
              "createDate" : "2016-12-24 22:42"
            }, {
              "username" : "p1alex22",
              "namecn" : "李四22",
              "createDate" : "2016-12-24 22:42"
            } ],
            "updated" : [ {
              "username" : "p2alex21",
              "namecn" : "李四211",
              "createDate" : "2016-12-24 22:42"
            }, {
              "username" : "p2alex22",
              "namecn" : "李四985",
              "createDate" : "2016-12-24 22:42"
            } ],
            "deleted" : [ {
              "username" : "p3alex21",
              "namecn" : "李四del211",
              "createDate" : "2016-12-24 22:42"
            }, {
              "username" : "p3alex22",
              "namecn" : "李四del985",
              "createDate" : "2016-12-24 22:42"
            } ]
          }
    }]}'



curl -H accept:application/json -H content-type:application/json \
  -u neo4j:123456  http://localhost:7474/db/data/transaction/commit \
  -d '{"statements":[{
        "statement":"WITH {p1:{inserted}} AS events   FOREACH (u1 IN events.p1 | CREATE (n:User) SET n = u1)       WITH {p2:{updated}} AS events  FOREACH (u2 IN events.p2 | MERGE (n:User {username:u2.username}) SET n.namecn = u2.namecn,  n.createDate = u2.createDate)   WITH {p3:{deleted}} AS events  UNWIND events.p3  AS u3  MATCH (n:User{username:u3.username}) OPTIONAL MATCH (n)-[r]-() DELETE n,r ",
         "parameters":{"updated":[{"createDate":"2016-12-24 22:42","username":"alex21","namecn":"李四5555"},{"createDate":"2016-12-24 22:42","username":"alex22","namecn":"李四5555"}],"rows":10,"inserted":[{"status":"P","username":"111","namecn":"111","createDate":"111"}],"deleted":[{"createDate":"2016-12-24 22:42","username":"alex21","namecn":"李四21"},{"createDate":"2016-12-24 22:42","username":"alex22","namecn":"李四22"}],"page":1}
    }]}'


--组织机构树查询
curl -H accept:application/json -H content-type:application/json \
  -u neo4j:123456  http://localhost:7474/db/data/transaction/commit \
  -d '{"statements":[{
        "statement":"MATCH p=(n:Group {name:{rootname}})-[:PCGROUP*]-(m) WITH COLLECT(p) AS ps  CALL apoc.convert.toTree(ps) yield value   RETURN value;",
         "parameters":{"rootname":"系统-sys","page":1}
    }]}'

--角色列表
curl -H accept:application/json -H content-type:application/json \
  -u neo4j:123456  http://localhost:7474/db/data/transaction/commit \
  -d '{"statements":[{
        "statement":"MATCH (n:Role) return COLLECT(n)",
         "parameters":{"rootname":"系统-sys","page":1}
    }]}'


--返回角色列表，已经组织机构的名称



curl -H accept:application/json -H content-type:application/json \
  -u neo4j:123456  http://localhost:7474/db/data/transaction/commit \
  -d '{"statements":[{
        "statement":"MATCH (role:Role)   OPTIONAL MATCH (group:Group)-[gr:GR]->(r1:Role{role_id:role.role_id})   OPTIONAL MATCH (r2:Role{role_id:role.role_id})-[ra:RA]->(auth:Auth) with  role,collect(group.group_id) as orgs ,collect(group.name) as orglist ,collect(DISTINCT auth.auth_id) as auths ,collect(DISTINCT auth.auth_id) as authlist return collect({role_id:role.role_id,name:role.name,createDate:role.createDate,orgs:orgs,orglist:orglist,auths:auths,authlist:authlist})",
         "parameters":{"rootname":"系统-sys","page":1}
    }]}'

OPTIONAL MATCH语句，它表示我们希望始终返回原始的 role; 相当于 sql 的左链接；

MATCH (role:Role) OPTIONAL MATCH (group:Group)-[gr:GR]->(r1:Role{role_id:role.role_id}) OPTIONAL MATCH  (r2:Role{role_id:role.role_id})-[ra:RA]->(auth:Auth)
 with  role,collect(group.group_id) as orgs ,collect(group.name) as orglist ,collect(auth.auth_id) as auths ,collect(auth.auth_id) as authlist
 return collect({role_id:role.role_id,name:role.name,createDate:role.createDate,orgs:orgs,orglist:orglist,auths:auths,authlist:authlist})

MATCH (role:Role)
OPTIONAL MATCH (group:Group)-[gr:GR]->(r1:Role{role_id:role.role_id})
OPTIONAL MATCH  (r2:Role{role_id:role.role_id})-[ra:RA]->(auth:Auth)
WITH role,collect(group.group_id) as orgs ,collect(group.name) as orglist ,collect(auth.auth_id) as auths ,collect(auth.auth_id) as authlist
 return collect({role_id:role.role_id,name:role.name,createDate:role.createDate,
 orgs:orgs,orglist:orglist,
 auths:auths,authlist:authlist})



WITH {json} as data
UNWIND data.items as q
MERGE (question:Question {id:q.question_id}) ON CREATE
      SET question.title = q.title,
          question.share_link = q.share_link,
          question.favorite_count = q.favorite_count

MERGE (owner:User {id:q.owner.user_id}) ON CREATE
      SET owner.display_name = q.owner.display_name
MERGE (owner)-[:ASKED]->(question)

FOREACH (tagName IN q.tags | MERGE (tag:Tag {name:tagName}) MERGE (question)-[:TAGGED]->(tag))
FOREACH (a IN q.answers |
   MERGE (question)<-[:ANSWERS]-(answer:Answer {id:a.answer_id})
   MERGE (answerer:User {id:a.owner.user_id}) ON CREATE SET answerer.display_name = a.owner.display_name
   MERGE (answer)<-[:PROVIDED]-(answerer)
)






//用户增删改查crud 创建用户
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



json tree 存储到neo4j

//JS调用
var r=require("request");
var neo4jUrl = (env["NEO4J_URL"] || "http://localhost:7474") + "/db/data/transaction/commit";

function cypher(query,params,cb) {
  r.post({uri:neo4jUrl,
          json:{statements:[{statement:query,parameters:params}]}},
         function(err,res) { cb(err,res.body)})
}

var query="UNWIND {json} AS data ....";
var apiUrl = "https://api.stackexchange.com/2.2/questions....";

r.get({url:apiUrl,json:true,gzip:true}, function(err,res,json) {
  cypher(query,{json:json},function(err, result) { console.log(err, JSON.stringify(result))});
});

//查询创建语句
WITH {json} as data
UNWIND data.items as q
MERGE (question:Question {id:q.question_id}) ON CREATE
      SET question.title = q.title,
          question.share_link = q.share_link,
          question.favorite_count = q.favorite_count

MERGE (owner:User {id:q.owner.user_id}) ON CREATE
      SET owner.display_name = q.owner.display_name
MERGE (owner)-[:ASKED]->(question)

FOREACH (tagName IN q.tags | MERGE (tag:Tag {name:tagName}) MERGE (question)-[:TAGGED]->(tag))
FOREACH (a IN q.answers |
   MERGE (question)<-[:ANSWERS]-(answer:Answer {id:a.answer_id})
   MERGE (answerer:User {id:a.owner.user_id}) ON CREATE SET answerer.display_name = a.owner.display_name
   MERGE (answer)<-[:PROVIDED]-(answerer)
)




Overall Response Structure

{ "items": [{
    "question_id": 24620768,
    "link": "http://stackoverflow.com/questions/24620768/neo4j-cypher-query-get-last-n-elements",
    "title": "Neo4j cypher query: get last N elements",
    "answer_count": 1,
    "score": 1,
    .....
    "creation_date": 1404771217,
    "body_markdown": "I have a graph....How can I do that?",
    "tags": ["neo4j", "cypher"],
    "owner": {
        "reputation": 815,
        "user_id": 1212067,
        ....
        "link": "http://stackoverflow.com/users/1212067/"
    },
    "answers": [{
        "owner": {
            "reputation": 488,
            "user_id": 737080,
            "display_name": "Chris Leishman",
            ....
        },
        "answer_id": 24620959,
        "share_link": "http://stackoverflow.com/a/24620959",
        ....
        "body_markdown": "The simplest would be to use an ... some discussion on this here:...",
        "title": "Neo4j cypher query: get last N elements"
    }]
 }



jsmind-json
{"meta":{"name":"jsMind remote","author":"hizzgdev@163.com","version":"0.2"},"format":"node_tree","data":{"id":"root","topic":"jsMind","expanded":true,"children":[{"id":"easy","topic":"Easy","expanded":true,"direction":"left","children":[{"id":"easy1","topic":"Easy to show","expanded":true},{"id":"easy2","topic":"Easy to edit","expanded":true},{"id":"easy3","topic":"Easy to store","expanded":true},{"id":"easy4","topic":"Easy to embed","expanded":true},{"id":"other3","expanded":true,"background-image":"ant.png","width":"100","height":"100"}]},{"id":"open","topic":"Open Source","expanded":true,"direction":"right","children":[{"id":"open1","topic":"on GitHub","expanded":true,"background-color":"#eee","foreground-color":"blue"},{"id":"open2","topic":"BSD License","expanded":true}]},{"id":"powerful","topic":"Powerful","expanded":true,"direction":"right","children":[{"id":"powerful1","topic":"Base on Javascript","expanded":true},{"id":"powerful2","topic":"Base on HTML5","expanded":true},{"id":"powerful3","topic":"Depends on you","expanded":true}]},{"id":"other","topic":"test node","expanded":true,"direction":"left","children":[{"id":"other1","topic":"I'm from local variable","expanded":true},{"id":"other2","topic":"I can do everything","expanded":true}]}]}}