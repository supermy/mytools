#version 5.6.22
FROM mysql:latest

RUN  sed -i '/client\]/a  max_allowed_packet = 48M ' /etc/mysql/my.cnf
RUN  sed -i '/mysqld\]/a   \
event_scheduler=ON   \n\
default-storage-engine=INNODB   \n\
#default-character-set=utf8    \n\
character-set-server = utf8    \n\
max_allowed_packet = 16M    \n\
wait_timeout	= 500    \n\
interactive_timeout	= 500    \n\
connect_timeout = 20    \n\
           \n\
back_log = 512      \n\
max_connections = 2048     \n\
max_connect_errors = 128    \n\
open_files_limit = 8192    \n\
    \n\
key_buffer_size = 1024M    \n\
    \n\
sort_buffer_size = 32M    \n\
read_buffer_size = 32M    \n\
join_buffer_size = 32M    \n\
read_rnd_buffer_size = 8M    \n\
bulk_insert_buffer_size = 32M    \n\
    \n\
thread_cache_size = 64    \n\
thread_stack = 512k    \n\
    \n\
query_cache_limit = 4M    \n\
query_cache_size = 128M    \n\
query_cache_min_res_unit= 2k    \n\
    \n\
#table_cache = 2048    \n\
tmp_table_size = 256M    \n\
max_heap_table_size = 256M    \n\
max_tmp_tables = 512    \n\
bulk_insert_buffer_size = 16M    \n\
skip-name-resolve    \n\
slow_query_log    \n\
long_query_time = 0.1    \n\
                        ' /etc/mysql/my.cnf


RUN  more /etc/mysql/my.cnf
