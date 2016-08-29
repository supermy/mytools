#!/bin/bash
# 自行编译KafkaOffsetMonitor
java -cp KafkaOffsetMonitor-assembly-0.2.0.jar \
     com.quantifind.kafka.offsetapp.OffsetGetterWeb \
     --zk 192.168.59.103 \
     --port 8080 \
     --refresh 10.seconds \
     --retain 2.days