#!/usr/bin/env bash
mkdir 6381
mkdir 6382
mkdir 6383
mkdir 6384
mkdir 6385
mkdir 6386

cd 6381
/usr/local/opt/redis/bin/redis-server ../redis1.conf   &
ls
cd ..
cd 6382
/usr/local/opt/redis/bin/redis-server ../redis2.conf   &
ls
cd ..
cd 6383
/usr/local/opt/redis/bin/redis-server ../redis3.conf   &
ls
cd ..
cd 6384
/usr/local/opt/redis/bin/redis-server ../redis4.conf   &
ls
cd ..
cd 6385
/usr/local/opt/redis/bin/redis-server ../redis5.conf   &
ls
cd ..
cd 6386
/usr/local/opt/redis/bin/redis-server ../redis6.conf   &
ls
cd ..
echo 'start finish ......'