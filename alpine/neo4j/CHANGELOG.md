2017-03-15
    用户与角色 用户与组织机构的关系处理；首先清除原有的关系
    2017-03-13

    
2017-03-13
    返回组织结构树
        MATCH p=(n:Group {name:'系统-sys'})-[:PCGROUP*]-(m)
                WITH COLLECT(p) AS ps
                CALL apoc.convert.toTree(ps) yield value
                RETURN value;
                
    
        MATCH p=(n:Resource {name:'根节点'})-[:PCRES*]-(m)
        WITH COLLECT(p) AS ps
        CALL apoc.convert.toTree(ps) yield value
        RETURN value;
        
        
2017-02-13
    增加插件
    https://github.com/neo4j-contrib/neo4j-apoc-procedures
    
    --示例
    WITH 'https://raw.githubusercontent.com/neo4j-contrib/neo4j-apoc-procedures/master/src/test/resources/person.json' AS url
    CALL apoc.load.json(url) YIELD value as person
    MERGE (p:Person {name:person.name})
       ON CREATE SET p.age = person.age, p.children = size(person.children)
       
    MATCH p=(n:Resource {name:'根节点'})-[:PCRES*]-(m)
    WITH COLLECT(p) AS ps
    CALL apoc.convert.toTree(ps) yield value
    RETURN value;
    
    --示例2
    CREATE
      (c1:Category {name: 'PC'}),
        (c1)-[:subcategory]->(c2:Category {name: 'Parts'}),
          (c2)-[:subcategory]->(c3:Category {name: 'CPU'}),
            (c3)-[:subcategory]->(c4:Category {name: 'CacheRAM'}),
        (c1)-[:subcategory]->(c5:Category {name: 'Accessories'}),
          (c5)-[:subcategory]->(c6:Category {name: 'Mouse'}),
          (c5)-[:subcategory]->(c7:Category {name: 'Keyboard'}),
      (c10:Category {name: 'Laptop'}),
        (c10)-[:subcategory]->(c20:Category {name: 'Parts'}),
          (c20)-[:subcategory]->(c30:Category {name: 'CPU'}),
        (c10)-[:subcategory]->(c40:Category {name: 'Accessories'}),
          (c40)-[:subcategory]->(c50:Category {name: 'Stylus'});
    
    MATCH p=(n:Category)-[:subcategory*]->(m)
    WHERE NOT ()-[:subcategory]->(n)
    WITH COLLECT(p) AS ps
    CALL apoc.convert.toTree(ps) yield value
    RETURN value;
    
    --示例3
    MERGE (M1:TREE {name:'m1'}) MERGE (M2:TREE {name:'m2'})
    MERGE (M3:TREE {name:'m3'}) MERGE (M4:TREE {name:'m4'})
    MERGE (M5:TREE {name:'m5'}) MERGE (M6:TREE {name:'m6'})
    MERGE (M7:TREE {name:'m7'}) MERGE (M8:TREE {name:'m8'})
    MERGE (M9:TREE {name:'m9'}) MERGE (M10:TREE {name:'m10'})
    MERGE (M1)-[:hasChild]->(M2) MERGE (M2)-[:hasChild]->(M4)
    MERGE (M4)-[:hasChild]->(M5) MERGE (M1)-[:hasChild]->(M3)
    MERGE (M7)-[:hasChild]->(M8) MERGE (M7)-[:hasChild]->(M9)
    MERGE (M7)-[:hasChild]->(M10)
    
    // Get leaf
    MATCH (T:TREE) WHERE NOT (T)-[:hasChild]->(:TREE) WITH T
    // Get branches
    OPTIONAL MATCH path = (P:TREE)-[:hasChild*0..]->(T) WHERE NOT (P)<-[:hasChild]-()
    WITH collect(path) as paths
    // Convert paths to tree
    CALL apoc.convert.toTree(paths) YIELD value
    RETURN value as tree
       
2017-01-25
    关系数据库数据导入到neo4j
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
                 --relationships:GU=/csvs/group-users.csv \
                 --relationships:GR=/csvs/group-roles.csv \
                 --relationships:ARES=/csvs/auth-resources.csv \
                 --relationships:PCRES=/csvs/resourcespc_head.csv,/csvs/resources.csv \
                 --relationships:PCGROUP=/csvs/grouppc_head.csv,/csvs/groups.csv"
