printjson(1);
sh.addShard("rs1/172.17.0.178:27017");
sh.addShard("rs2/172.17.0.172:27017");
sh.status();

db.runCommand( { listshards : 1 } );
db.runCommand( { enablesharding:"test" });
db.runCommand( { shardcollection : "test.c1",key : {id: 1} } );
db = db.getSiblingDB("test");
for(var i=1;i<=2000;i++) db.c1.save({id:i,value1:"12345678"});
db.c1.stats();
