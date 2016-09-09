#!/bin/sh
set -e

if [ "${1:0:1}" = '-' ]; then
	set -- mongod "$@"
fi
# allow the container to be started with `--user`
if [ "$1" = 'mongod' ]; then
	chown -R mongodb /data/db
fi

exec "$@"