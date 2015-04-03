fig up -d && fig ps
kafka-topics.sh --create --zookeeper 192.168.59.103:2181 --replication-factor 1 --partitions 1 --topic storm-sentence
fig logs flume1