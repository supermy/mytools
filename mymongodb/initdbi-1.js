printjson(1);
config={_id: 'rs1', members:[{_id: 0,host:'172.17.1.9:27017'},{_id:1,host:'172.17.1.5:27017'},{_id:2,host:'172.17.1.7:27017'}]}
rs.initiate(config);
