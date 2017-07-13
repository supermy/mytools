import com.google.gson.Gson

//数据加工为 lua 脚本，插入到 redis
println "netuser redis script remark......"
println head
//println body

//body = "2017-06-22 10:14:48.93858150001221.203.101.54000127.209.182.50001Mozilla/4.0 "

//ZRANGE 113.230.118.55 0 -1 withscores
//ZRANGEBYSCORE 113.230.118.55 20170609190320 +inf LIMIT 0 1
//如果查询到@End 结尾，则将账号插入到队列
//eval "local obj=redis.call('ZRANGEBYSCORE',KEYS[1],ARGV[1],ARGV[2],'LIMIT',ARGV[3],ARGV[4]);if obj[1] == nil then return false end;local objlen=string.len(obj[1]);local objend=string.sub(obj[1],objlen-3);if objend=='@End' then local act=string.sub(obj[1],1,objlen-4);local netlogact=KEYS[1]..'|'..ARGV[1]..'|'..act;redis.call('lpush', KEYS[2],netlogact ) ;return netlogact; else return false ; end" 2 113.230.118.55 netlogactlist  20170609190320 +inf 0 1


//def split = body.split("0001")  //fixme
def split = body.split("\\u0001")  //fixme  hive 分隔符号  \u0001
println split.size()
println split[0]
println split[1]
println split[2]


StringBuffer script=new StringBuffer("local obj=redis.call('ZRANGEBYSCORE',KEYS[1],ARGV[1],ARGV[2],'LIMIT',ARGV[3],ARGV[4]);if obj[1] == nil then return false end;local objlen=string.len(obj[1]);local objend=string.sub(obj[1],objlen-3);if objend=='@End' then local act=string.sub(obj[1],1,objlen-4);local netlogact=KEYS[1]..'|'..ARGV[1]..'|'..act;redis.call('lpush', KEYS[2],netlogact ) ;return netlogact; else return false ; end");

StringBuffer keys=new StringBuffer();
keys.append(split[1]).append(";")
keys.append("netlogactlist")
//println keys.toString().split(";");

StringBuffer args=new StringBuffer();
String curdate = split[0].split("\\.")[0]
String curstr = curdate.replaceAll(":","").replaceAll("-","").replaceAll(" ","");
args.append(curstr).append(";")
args.append("+inf").append(";")
args.append("0").append(";")
args.append("1")
//println args.toString().split(";")


Gson gson = new Gson();


Map full= new HashMap();
full.put("script",script.toString());//script.toString() redis.log(redis.LOG_WARNING, "Something is wrong with this script.")
full.put("args",Arrays.asList(args.toString().split(";")));
full.put("keys",Arrays.asList(keys.toString().split(";")));

String json = gson.toJson(full);

println json

def resultMap = [:]

resultMap["head"] = head
resultMap["body"] = json

return resultMap