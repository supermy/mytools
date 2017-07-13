#!/usr/bin/awk -f
# 转换为 json 格式awk 脚本
# for i in conf/data/netlog*.txt; do awk -F'\001' -v q='"' -v debug=1  -f conf/g-tojson.awk $i; done


BEGIN{ OFS=",";now=strftime("%Y%m%d%H%M%S");}

#构造 json 函数
function json(x,y){printf("%s:%s,",q x q, q y q)}
function jsonend(x,y){printf("%s:%s",q x q, q y q)}

#debug {printf("NR=%d, FNR=%d, NF=%d, $0=\"%s\"\n", NR, FNR, NF, $0")}
debug {printf("NR=%d, FNR=%d, NF=%d, \n", NR, FNR, NF)}

{
#过滤数据

#数据准备 构造指定的时间数据
gsub("-","",$1);
gsub(":","",$1);
gsub(" ","",$1);
split($1,a,".");

#10天前的数据
###print now-18000000
###print a[1]
#进行数据处理
if ((now-18000000)<=a[1])
 {
###构造json
    printf "{"

    json("arg",a[1]);
    jsonend("key",$2);

    print "}"
 }
    else
 {
    print "no do";
 }


}

END {}
