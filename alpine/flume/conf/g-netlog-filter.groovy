import java.text.SimpleDateFormat
import java.util.regex.Matcher
import java.util.regex.Pattern

//#当它的值为false 的时候，过滤掉匹配到当前正则表达式的一行
//#当它的值为true的时候，就接受匹配到正则表达式的一行

//println "netlog filter"
//println head
//println body
//body = "2017-06-22 10:14:48.93858150001221.203.101.54000127.209.182.50001Mozilla/4.0 "

def split = body.split("\\u0001")  //fixme  hive 分隔符号  \u0001

//println split.size()

if(split.size()<4){
    //数据不合格过滤 网络日志数据至少有4列
    return false;
}


//非法 IP 地址过滤掉
//String ip = "^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\.(00?\\d|1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(00?\\d|1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(00?\\d|1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\$"
//Pattern pattern = Pattern.compile(ip);
//Matcher matcher = pattern.matcher(split[1]);
//if(!matcher.matches()){
//    //数据不合格过滤 网络日志数据至少有4列
//    println '非法IP-1';
//    return false;
//}

//非法日期
String curdate = split[0].split("\\.")[0]
String curstr = curdate.replaceAll(":","").replaceAll("-","").replaceAll(" ","");

//println curstr

//3daybefore 系统时间
Calendar date = Calendar.getInstance();
date.set(Calendar.DATE, date.get(Calendar.DATE) - 3);
cur3daytime = date.format('yyyyMMddHHmmss')

//println cur3daytime

//3daybefore
//if (cur3daytime > curstr){
//    println "data time drop";
//    return false;
//}

//println split[0]
//println split[1]
//println split[2]
////println split[3]
//
//String curdate = split[0].split("\\.")[0]
//String curstr = curdate.replaceAll(":","").replaceAll("-","").replaceAll(" ","");
//println curstr

//第一个 IP 地址作为终端 IP
def type = split[1]

if (type.substring(0,2) != '10') {
    return true;  //不过滤
} else {
//    println '非法IP-2';
    return false; //过滤
}
