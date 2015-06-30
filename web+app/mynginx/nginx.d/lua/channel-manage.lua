local template = require "resty.template"



--模板嵌套的例子
--id/name/code/pwd/token/token_expire/iplist/ip_bind_time/ip_time_out/connect_count/limit_bandwidth/status/
template.render("channel-list.html", { channels = {
    {id=1,name = "Jane", code = "1001" ,pwd="asdfkjs;dlkfjqwer",token_expire="10",
        iplist="192.168.59.3",
        ip_bind_time=60,ip_time_out=60,connect_count=300,limit_bandwidth="10M",status=1},
    {id=1,name = "Jane", code = "1001" ,pwd="asdfkjs;dlkfjqwer",token_expire="10",
        iplist="192.168.59.3",
        ip_bind_time=60,ip_time_out=60,connect_count=300,limit_bandwidth="10M",status=1},
    {id=1,name = "Jane", code = "1001" ,pwd="asdfkjs;dlkfjqwer",token_expire="10",
        iplist="192.168.59.3",
        ip_bind_time=60,ip_time_out=60,connect_count=300,limit_bandwidth="10M",status=1},
    {id=1,name = "Jane", code = "1001" ,pwd="asdfkjs;dlkfjqwer",token_expire="10",
        iplist="192.168.59.3",
        ip_bind_time=60,ip_time_out=60,connect_count=300,limit_bandwidth="10M",status=1},
    {id=1,name = "Jane", code = "1001" ,pwd="asdfkjs;dlkfjqwer",token_expire="10",
        iplist="192.168.59.3",
        ip_bind_time=60,ip_time_out=60,connect_count=300,limit_bandwidth="10M",status=1}
}})

