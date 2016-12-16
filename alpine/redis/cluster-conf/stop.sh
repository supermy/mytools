#!/usr/bin/env bash
ps -ef|grep :638|awk '{print $2}'|xargs kill -9
rm -rf 6381
rm -rf 6382
rm -rf 6383
rm -rf 6384
rm -rf 6385
rm -rf 6386