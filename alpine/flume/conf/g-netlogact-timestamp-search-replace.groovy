import java.text.SimpleDateFormat

//时间戳 hdfs 分卷使用
//println " netlogact redis script remark......"
//println head
//println body

//body = "221.200.83.69|20170624112313|my_19780808"

def split = body.split("\\|")

def time = split[1]
println time

SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
Date cur = formatter.parse(time);

println time
println cur.format("yyyyMMddHHmmss")
println cur.getTime()

head["timestamp"]=cur.getTime();

def resultMap = [:]

resultMap["head"] = head
resultMap["body"] = body

return resultMap