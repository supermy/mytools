FROM alpine

LABEL com.stdmachine.description="alpine nodejs image" \
      com.stdmachine.role="nodejs image"

RUN apk update && apk upgrade
RUN apk add nodejs

WORKDIR /app
ADD . /app
ENTRYPOINT [ "node", "server.js" ]