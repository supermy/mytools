printjson(1);
config={_id: 'rs1', members:[{_id: 0,host:'172.17.4.28:27017'},{_id:1,host:'172.17.4.26:27017'},{_id:2,host:'172.17.4.27:27017'}]}
rs.initiate(config);
