FROM    debian:wheezy

# Add 10gen official apt source to the sources list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list

RUN apt-get update
RUN apt-get install adduser -y
RUN apt-get install apt-utils -y
#RUN apt-get install -y mongodb-org
RUN  apt-get install -y mongodb-org=2.6.1 mongodb-org-server=2.6.1 mongodb-org-shell=2.6.1 mongodb-org-mongos=2.6.1 mongodb-org-tools=2.6.1


# Create the MongoDB data directory
RUN mkdir -p /data/db

# Define mountable directories.
#VOLUME ["/data/db"]

# Define working directory.
#WORKDIR /data

EXPOSE 27017
EXPOSE 28017
ENTRYPOINT ["/usr/bin/mongod"]