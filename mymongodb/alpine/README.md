2016-03-18

# MongoDB in a box

(!!! mongodb@testing over alpine:edge !!!) AlpineLinux-base Docker image with MongoDB


docker build -t supermy/docker-mongodb:ap -f mymongodb/alpine/Dockerfile mymongodb/alpine


## Usage

as Server:

    docker run -d --name mongodb -p 27017:27017 -v /data/mongodb:/var/lib/mongodb supermy/docker-mongodb:ap

as Client:

    docker run -it --rm supermy/docker-mongodb:ap mongo --help

## Configuration

You may pass config options via command line, as you normally would:

    docker run -d -p 27017:27017 \
      -v /data/mongodb:/var/lib/mongodb \
      supermy/docker-mongodb:ap --storageEngine wiredTiger
