import com.google.gson.Gson

//数据加工为 lua 脚本，插入到 redis
//println "netuser redis script remark......"
//println head
//println body

//body = "20170621162925,113.225.23.151,test_10056368,1"
//body = "20170621162925,113.225.23.152,test_10056368,2"
// eval "return redis.call('ZADD','KEYS[1]',ARGV[1],ARGV[2])" 1 keyset   123  u123

def split = body.split(",")

def type = split[3]
split[3]=type.substring(0,1)
if (type.substring(0,1) == '1') {
    split[2]=split[2]+"@Start";
} else {
    split[2]=split[2]+"@End";
}

Gson gson = new Gson();

//String key =  m.get("key").toString();
//String score =  m.get("score").toString();
//String member =  m.get("member").toString();

Map full= new HashMap();

full.put("key",split[1]);
full.put("score",split[0]);
full.put("member",split[2]);

String json = gson.toJson(full);

//println json

def resultMap = [:]

resultMap["head"] = head
resultMap["body"] = json

return resultMap