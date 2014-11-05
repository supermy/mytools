FROM    debian:latest

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install locales && \
    sed -i.bak -e 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    update-locale LC_ALL= "zh_CN.UTF-8" && \
    export LANGUAGE=zh_CN:cn && \
    export LANG=zh_CN.UTF-8 && \
    export LC_ALL=zh_CN.UTF-8 && \
    dpkg-reconfigure locales && \


	apt-get install -y curl \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.1/gosu' \
	&& chmod +x /usr/local/bin/gosu

#userage
#docker build -t mydev/debian test