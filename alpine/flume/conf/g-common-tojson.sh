#!/usr/bin/awk -f
# 转换为 json 格式awk 脚本

{a[$1]=a[$1]?a[$1]"\t"$2"\t"$3"\t"$4:$2"\t"$3"\t"$4
 }END{
for(i in a){
        printf i"\t[";l=split(a[i],b,"\t");
                for(j=1;j<=l;j+=3){
                    printf "{h_name"":"q b[j] q",";
                    printf "level"":"q b[j+1] q","
                  }
        print "]"
        }
}
