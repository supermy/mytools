# Alpine Linux RabbitMQ Docker image
Many other RabbitMQ Docker images are [huge](https://imagelayers.io/?images=rabbitmq:latest,frodenas%2Frabbitmq:latest,tutum%2Frabbitmq:latest).  Instead of using the bloated Ubuntu or Fedora images as a base, this image uses the 5MB Alpine Linux base image.  Alpine lets us run RabbitMQ 3.6.1 on Erlang 18.3.2 in only **37MB**!

### Usage
The wrapper script starts RabbitMQ (with management plugin enabled), tails the log, and configures listeners on the standard ports:
  - `5671/tcp`: Listening port when SSL is enabled
  - `5672/tcp`: Non-SSL default listening port
  - `15671/tcp`: SSL GUI listening port
  - `15672/tcp`: Non-SSL GUI listening port

RabbitMQ's data is persisted to a volume at `/var/lib/rabbitmq`.

To enable SSL set the `SSL_CERT_FILE`, `SSL_KEY_FILE`, and `SSL_CA_FILE` environment variables.  The wrapper script will use the same certs for GUI SSL access as for AMQPS access.

**2/10/16**: We've added the [autocluster](https://github.com/aweber/rabbitmq-autocluster) plugin to this image. To enable it, set the `AUTOCLUSTER_TYPE` environment variable to your backend (we've tested with Consul). See the autocluster [docs](https://github.com/aweber/rabbitmq-autocluster#configuration) for details on what additional options can be set for provided backends.

***Examples:***
```bash
# Run without TLS
docker run -d \
  --name rabbitmq \
  -p 5672:5672 \
  -p 15672:15672 \
  gonkulatorlabs/rabbitmq
```

```bash
# Run with TLS enabled
docker run -it \
  --name rabbitmq \
  -p 5671:5671 \
  -p 15671:15671 \
  -e SSL_CERT_FILE=/ssl/cert/cert.pem \
  -e SSL_KEY_FILE=/ssl/cert/key.pem \
  -e SSL_CA_FILE=/ssl/CA/cacert.pem \
  gonkulatorlabs/rabbitmq
```

```bash
# Run with autoclustering enabled
#   These options will register the RMQ
#   node as living on 192.168.99.101.
#   Nodes that join will attempt to cluster
#   on that address.
docker run -d \
  --name rabbitmq \
  -e AUTOCLUSTER_TYPE=consul \
  -e CONSUL_HOST=192.168.99.101 \
  -p 5672:5672 \
  -p 15672:15672 \
  gonkulatorlabs/rabbitmq
```

### Customizing
To set a custom config, ditch the wrapper script and call `rabbitmq-server` directly.  Place the custom config in `/srv/rabbitmq_server-3.6.0/etc/rabbitmq/`. To reduce startup complexity, the autocluster plugin is not enabled by default (our wrapper script enables it on demand). If you want to use it with a custom config, make sure to run `rabbitmq-plugins enable --offline autocluster` in the container before starting Rabbit.

### Fair Warning!
Alpine's Erlang packages are in its `edge` (testing) repo, if that bothers you then don't use this image!