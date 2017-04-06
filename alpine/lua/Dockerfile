FROM alpine:3.4

MAINTAINER JamesMo  <springclick@gmail.com>

# Install Lua and LuaRocks
# Version of Lua we're building the image for.
ENV LUA_VERSION 5.2
ENV LUA_PACKAGE lua${LUA_VERSION}

RUN apk --no-cache add ca-certificates curl unzip build-base git bash \
    tini \
    bash    \
    ${LUA_PACKAGE}  \
    ${LUA_PACKAGE}-dev


# Build Luarocks.
RUN cd /tmp && \
    git clone https://github.com/keplerproject/luarocks.git && \
    cd luarocks && \
    sh ./configure && \
    make build install && \
    cd && \
    rm -rf /tmp/luarocks

RUN     ln -s /usr/bin/lua5.2 /usr/bin/lua   && chmod a+x /usr/bin/lua

#CMD ["bash"]
ENTRYPOINT ["/usr/bin/tini", "--", "lua"]

#docker run --rm -it supermy/ap-lua
#= 6 * 7
#os.exit(0)
#RUN apk add --update gcc lua5.2-dev musl-dev git \
#    && export C_INCLUDE_PATH=/usr/include/lua5.2/ \
#    && luarocks install httpclient \
#    && luarocks install lua-cjson \
#    && apk del gcc lua5.2-dev musl-dev git \
#    && rm -rf /var/cache/apk/*

