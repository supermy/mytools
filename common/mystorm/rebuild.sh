#!/bin/bash
docker build -t jamesmo/storm_base:0.9.3 mystorm/storm
docker build -t jamesmo/storm-nimbus:0.9.3 mystorm/storm-nimbus
docker build -t jamesmo/storm-supervisor:0.9.3 mystorm/storm-supervisor
docker build -t jamesmo/storm-ui:0.9.3 mystorm/storm-ui
