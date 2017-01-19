2017-01-10

By default the Docker image exposes three ports for remote access:

    7474 for HTTP.
    7473 for HTTPS.
    7687 for Bolt.
    It also exposes two volumes:

    /data to allow the database to be persisted outside its container.
    /logs to allow access to Neo4j log files.

各种neo4j 参数配置
https://neo4j.com/docs/operations-manual/current/installation/docker/

docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$HOME/neo4j/data:/data \
    --volume=$HOME/neo4j/logs:/logs \
    --ulimit=nofile=40000:40000 \
    neo4j 

 
docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$HOME/neo4j/data:/data \
    --volume=$HOME/neo4j/logs:/logs \
    --ulimit=nofile=40000:40000 \
    neo4j:enterprise
