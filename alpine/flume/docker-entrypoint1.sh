#!/bin/bash

set -e

FLUME_CONF_DIR=${FLUME_CONF_DIR:-/opt/flume/conf}
FLUME_CONF_FILE=${FLUME_CONF_FILE:-/opt/flume/conf/flume-conf.properties}

[[ -z "${FLUME_AGENT_NAME}" ]] && { echo "FLUME_AGENT_NAME required"; exit 1; }

echo "Starting flume agent : ${FLUME_AGENT_NAME}"


if [ -z ${FLUME_MONITORING_TYPE} ]; then
    flume-ng agent -c ${FLUME_CONF_DIR} -f ${FLUME_CONF_FILE} -n ${FLUME_AGENT_NAME} -Dflume.root.logger=INFO,console
fi

echo ${FLUME_MONITORING_HOSTS};
echo ${FLUME_MONITORING_PORT};


if [ -n "${FLUME_MONITORING_HOSTS}" ]; then

    #[[ -z "${FLUME_MONITORING_HOSTS}" ]] && { echo "FLUME_MONITORING_HOSTS required"; exit 1; }
    flume-ng agent -c ${FLUME_CONF_DIR} -f ${FLUME_CONF_FILE} -n ${FLUME_AGENT_NAME} -Dflume.monitoring.type=${FLUME_MONITORING_TYPE} -Dflume.monitoring.hosts=${FLUME_MONITORING_HOSTS} -Dflume.root.logger=INFO,console
fi

if [ -n "${FLUME_MONITORING_PORT}" ]; then
    #[[ -z "${FLUME_MONITORING_HOSTS}" ]] && { echo "FLUME_MONITORING_HOSTS required"; exit 1; }
    flume-ng agent -c ${FLUME_CONF_DIR} -f ${FLUME_CONF_FILE} -n ${FLUME_AGENT_NAME} -Dflume.monitoring.type=${FLUME_MONITORING_TYPE} -Dflume.monitoring.port=${FLUME_MONITORING_PORT} -Dflume.root.logger=INFO,console
fi