FROM alpine
RUN apk update && apk upgrade
RUN apk add nodejs

WORKDIR /app
ADD . /app
ENTRYPOINT [ "node", "server.js" ]