printjson(1);
config={_id: 'rs2', members:[{_id: 0,host:'172.17.0.255:27017'},{_id:1,host:'172.17.1.1:27017'},{_id:2,host:'172.17.1.3:27017'}]}
rs.initiate(config);
