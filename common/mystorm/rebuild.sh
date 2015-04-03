#!/bin/bash

#docker build -t="storm_base" storm
docker build -t="storm-nimbus_base" storm-nimbus
docker build -t="storm-supervisor_base" storm-supervisor
docker build -t="storm-ui_base" storm-ui
