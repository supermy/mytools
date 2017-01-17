2017-01-17
    ganglia 配置 监控flume ;需要修改配置文件 gmetad.conf gmond.conf
    
    flume-fig.yml 内网地址可通
        FLUME_MONITORING_HOSTS: 172.17.0.2:8650
        FLUME_MONITORING_TYPE: ganglia
        
    ganglia-fig.yml    
      volumes:
        - ./conf:/etc/ganglia

    fig up -d && fig ps
    docker inspect ganglia_ganglia_1

    
2017-01-16

    同一个集群的ganglia 可以自动检测并且检测；
    docker run -rm \
      -name ganglia \
      -h my.fqdn.org \
      -v /path/to/conf:/etc/ganglia \
      -v /path/to/ganglia:/var/lib/ganglia \
      -p 0.0.0.0:80:80 \
      wookietreiber/ganglia
      --timezone Continent/City