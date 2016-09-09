# Docker Alpine Mongodb
- 1.0.0, latest[ (Dockerfile)](https://github.com/Ulbora/docker_alpine_mongodb/blob/1.0.0/Dockerfile)

This is Docker mongoDB running on Alpine
This will be the base container for all Ulbora Labs MongoDB Docker projects.
Currently this is not production ready, but will be moved to production when MongoDB is offered in the latest
Alpine container. Currently MongoDB is only available in Alpine:edge and may not be stable.

# Running
```
docker run -d -p 27017:27017 supermy/ap-mongodb:latest
```
#### or
```
docker run -d -p 27017:27017 -v /someLocalVolume:/data/db \ 
supermy/ap-mongodb:latest
```

# Connect to running instance
```
docker exec -it supermy/ap-mongodb:latest sh
```
