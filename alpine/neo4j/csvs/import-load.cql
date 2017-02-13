MATCH (u:User)-[ur:UR]->(r:Role) DELETE ur,r,u


LOAD CSV WITH HEADERS FROM "file:///csvs/users.csv" AS row
CREATE (u:User)
SET u = row


LOAD CSV WITH HEADERS FROM "file:///csvs/roles.csv" AS row
CREATE (r:Role)
SET r = row


CREATE INDEX ON :User(id)
CREATE INDEX ON :Role(role)

LOAD CSV WITH HEADERS FROM "file:///csvs/user-roles.csv" AS row
//MATCH (u:User), (r:Role)
//WHERE u.userID = row.userID AND r.roleID = row.roleID
CREATE (u)-[details:USERROLES]->(r);

//LOAD CSV WITH HEADERS FROM "file:///csvs/user-roles.csv" AS row
//MATCH (u:User {userID: row.userID})
//MATCH (r:Role {role: row.role})
//MERGE (u)-[ur:UR]->(r);

//#USING PERIODIC COMMIT
//#LOAD CSV WITH HEADERS FROM "file:orders.csv" AS row
//#MATCH (order:Order {orderID: row.OrderID})
//#MATCH (employee:Employee {employeeID: row.EmployeeID})
//#MERGE (employee)-[:SOLD]->(order);
//
//#USING PERIODIC COMMIT
//#LOAD CSV WITH HEADERS FROM "file:orders.csv" AS row
//#MATCH (order:Order {orderID: row.OrderID})
//#MATCH (customer:Customer {customerID: row.CustomerID})
//#MERGE (customer)-[:PURCHASED]->(order);


//
//MATCH (u:User)-[ur:USERROLES]->(r:Role)
//RETURN ur
//
//MATCH (u:User)-[:UR]->(r:Role)
//RETURN u.username,r.role

//LOAD CSV WITH HEADERS FROM "file:///friend-nodes.csv" AS nodes
//CREATE (p:Person { name: nodes.name })
//
//LOAD CSV WITH HEADERS FROM "file:///friend-edges.csv" AS edges
//MATCH (a:Person { name: edges.source})
//MATCH (b:Person { name: edges.target })
//CREATE (a)-[:HAS_FRIEND]->(b);
//
//MATCH (a:Person)-[:HAS_FRIEND]->(b:Person)
//RETURN a.name,b.name