FROM alpine:latest

MAINTAINER Nic Jackson jackson.nic@gmail.com

# add wget and tar
RUN apk add --update wget
RUN apk add --update tar
RUN apk add --update unzip

# consul-template
RUN wget --no-check-certificate https://releases.hashicorp.com/consul-template/0.11.1/consul-template_0.11.1_linux_386.zip; \
unzip consul-template_0.11.1_linux_386.zip; \
mv ./consul-template /usr/bin/consul-template; \
rm -rf consul-template_0.11.1_linux_386.zip; \
rm -rf consul-template

# skaware s6 daemon runner
RUN mkdir s6; \
wget --no-check-certificate  https://github.com/just-containers/skaware/releases/download/v1.16.1/s6-2.2.2.0-linux-amd64-bin.tar.gz; \
tar -xvzf s6-2.2.2.0-linux-amd64-bin.tar.gz --directory /s6 --strip-components=1; \
mv /s6/usr/bin/* /usr/bin; \
rm s6-2.2.2.0-linux-amd64-bin.tar.gz; \
rm -rf s6

RUN chmod -R 755 /usr/bin

ENTRYPOINT ["/usr/bin/s6-svscan","/etc/s6"]
CMD []