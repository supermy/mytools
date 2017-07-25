#!/usr/bin/awk -f
# 转换为 json 格式awk 脚本
# 按照效率最高的原则进行脚本处理  150w/10s   15万/秒；每多一条处理规则需要的时间更多；
# 更一步的提升采用多线程处理或者将文件拆分为多分进行并行处理
# 数据的有效率过滤 通过文件规则处理
# for i in conf/data/netlog*.txt; do awk -F'\001' -v q='"' -v debug=1  -f conf/g-tojson.awk $i; done
# time for i in conf/data/netlog*.txt; do awk -F'\001' -v q='"' -v debug=0  -f conf/g-tojson.awk $i>temp; done


#BEGIN{ OFS=",";now=strftime("%Y%m%d%H%M%S");}
#BEGIN{ OFS=",";}

#构造 json 函数
function json(x,y){return sprintf("%s:%s",q x q, q y q)}
function jsonend(x,y){return sprintf("%s:%s",q x q, q y q)}

#debug {printf("NR=%d, FNR=%d, NF=%d, $0=\"%s\"\n", NR, FNR, NF, $0)}
#debug {printf("NR=%d, FNR=%d, NF=%d, $0=\"%s\"\n", NR, FNR, NF, $0)}

{
#过滤数据

#数据准备 构造指定的时间数据

gsub("[-: ]","",$1); #3s
split($1,a,"."); #3s
print ("{" json("arg",a[1]) jsonend("key",$2) "}") #5s
#print $1 $2 # 3s

#10天前的数据
###print now-18000000
#print a[1]
#进行数据处理
#if ((now-18000000)<=a[1]) {
###构造json
# }
#    else {
#    print "no do";
# }


}

#END {}
