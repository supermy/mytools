import com.google.gson.Gson

//数据加工为 lua 脚本，插入到 redis
//println "netuser redis script remark......"
//println head
//println body

//body = "2017-06-22 10:14:48.93858150001221.203.101.54000127.209.182.50001Mozilla/4.0 "

//ZRANGE 113.230.118.55 0 -1 withscores
//ZRANGEBYSCORE 113.230.118.55 20170609190320 +inf LIMIT 0 1
//如果查询到@End 结尾，则将账号插入到队列


//def split = body.split("0001")  //fixme
def split = body.split("\\u0001")  //fixme  hive 分隔符号  \u0001
//println split.size()
//println split[0]
//println split[1]

String curdate = split[0].split("\\.")[0]
String curstr = curdate.replaceAll(":","").replaceAll("-","").replaceAll(" ","");

Map full= new HashMap();
full.put("arg",curstr);
full.put("key",split[1]);

Gson gson = new Gson();
String json = gson.toJson(full);

//println json


def resultMap = [:]

resultMap["head"] = head
resultMap["body"] = json

return resultMap