import com.google.gson.Gson

//数据加工为 lua 脚本，插入到 redis
println "market data to json"
//println head
//println body

def split = body.split("\\t")
println split.size()


Gson gson = new Gson();

//{ "ACCT_ID" : "$1", "ACTIVITY_ID" : "$2", "ACTIVITY_NAME" : "$3", "USER_GUEST_ID" : "$4", "USER_GUEST_NAME" : "$5",
// "DEPART_TYPE_ID" : "$6", "DEPART_DESCRIBE" : "$7", "MESSAGE" : "$8", "AREA_DESC" : "$9", "START_DATE" : "$10",
// "END_DATE" : "$11", "SEND_NUM" : "$12", "SEND_NUM_CALL" : "$13" , "CONTENT_SMS_CALL" : "$14",
// "CONTENT_SMS_CALL_2" : "$15", "CONTENT_SMS_CALL_3" : "$16", "IVR" : "$17", "PROV_ID" : "$18" , "AREA_ID" : "$19",
// "USER_ID" : "$20", "DEVICE_NUMBER" : "$21", "KUHU_ID" : "$22", "NUM1" : "$23" , "NUM2" : "$24", "NUM3" : "$25"}

Map full= new HashMap();
full.put("ACCT_ID",split[0]);
full.put("ACTIVITY_ID",split[1]);
full.put("ACTIVITY_NAME",split[2]);
full.put("USER_GUEST_ID",split[3]);
full.put("USER_GUEST_NAME",split[4]);
full.put("DEPART_TYPE_ID",split[5]);
full.put("DEPART_DESCRIBE",split[6]);
full.put("MESSAGE",split[7]);
full.put("AREA_DESC",split[8]);
full.put("START_DATE",split[9]);
full.put("END_DATE",split[10]);
full.put("SEND_NUM",split[11]);
full.put("SEND_NUM_CALL",split[12]);
full.put("CONTENT_SMS_CALL",split[13]);
full.put("CONTENT_SMS_CALL_2",split[14]);
full.put("CONTENT_SMS_CALL_3",split[15]);
full.put("IVR",split[16]);
full.put("PROV_ID",split[17]);
full.put("AREA_ID",split[18]);
full.put("USER_ID",split[19]);
full.put("DEVICE_NUMBER",split[20]);
full.put("KUHU_ID",split[21]);
full.put("NUM1",split[22]);
full.put("NUM2",split[23]);
full.put("NUM3",split[24]);


String json = gson.toJson(full);

println json

def resultMap = [:]

resultMap["head"] = head
resultMap["body"] = json

return resultMap