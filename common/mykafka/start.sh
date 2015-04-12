fig up -d && fig ps

#tese1
kafka-topics.sh --create --zookeeper 192.168.59.103:2181 --replication-factor 1 --partitions 1 --topic mykafka
telnet 192.168.59.103 44447
kafka-console-consumer.sh --zookeeper 192.168.59.103:2181 --topic mykafka --from-beginning

#test2
kafka-topics.sh --create --zookeeper 192.168.59.103:2181 --replication-factor 1 --partitions 1 --topic metadata
kafka-topics.sh --create --zookeeper 192.168.59.103:2181 --replication-factor 1 --partitions 1 --topic test
java -cp spring-kafka-demo-0.2.0-SNAPSHOT-jar-with-dependencies.jar com.colobu.spring_kafka_demo.Producer
java -cp spring-kafka-demo-0.2.0-SNAPSHOT-jar-with-dependencies.jar com.colobu.spring_kafka_demo.Consumer

fig stop && fig rm --force

echo "test over!"