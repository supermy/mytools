2017-01-16

    同一个集群的ganglia 可以自动检测并且检测；
    export JAVA_OPTS="-Xms100m -Xmx2000m -Dcom.sun.management.jmxremote -Dflume.monitoring.type=ganglia -Dflume.monitoring.hosts=127.0.0.1:8649”
    -Dflume.monitoring.type=ganglia -Dflume.monitoring.hosts=127.0.0.1:8649
    #配置gmetad
    
    data_source "flumeDataSrc" 10 192.168.150.140:8650
    data_source "meta_gmond" 10 192.168.147.72:8649
    
    ganglia分为三部分:
        
        服务端，客户端，web端
        gmetad，gmond，ganglia-web
        gmond是一个终端采集agent，负责收集机器信息，及flume传给他的信息
        gmetad就负责轮训配置的各个gmond机器，获取数据    
        ganglia-web是PHP实现的web站点
        
     udp_send_channel小节
     如果不配置，gmond进程相当于mute状态。允许出现多次。重要的属性如下：

     mcast_join：指定广播的目的IP地址，与host只能二选一  
     host：指定单播的目的IP地址，与mcast_join只能二选一  
     port：广播和单播中的目的UDP端口号，默认值为8649  
     ttl：数据存活时间  
 
    