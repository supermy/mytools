FROM supermy/ap-flume

MAINTAINER James Mo

#EXPOSE 44444

COPY conf /etc/flume/conf/
COPY plugins.d /opt/flume/plugins.d/

#镜像包构造命令
#docker build -t bonc/flume-sync -f Dockerfile-alone .

#拷贝镜像包到硬盘目录
#docker save -o ~/docker-save/flume-new.tar bonc/flume-sync:latest


#运行命令
#docker run \
#  -e FLUME_AGENT_NAME=a1 \
#  -e FLUME_CONF_DIR=/opt/flume/conf \
#  -e FLUME_CONF_FILE: /etc/flume/conf/flume-netcat2morphline-syslog2log.conf \
#  bonc/flume-sync
