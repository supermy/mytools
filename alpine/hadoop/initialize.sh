#!/bin/bash

docker-compose up -d namenode1 namenode2 && \
sleep 5 && \
docker exec -it hadoop27_namenode1_1 bash -c "bin/hdfs zkfc -formatZK" && \
docker-compose up -d && \
echo "ALL SERVICES STARTED!" && \
echo "TAILING LOGS" && \
docker-compose logs -f
