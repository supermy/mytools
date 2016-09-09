#!/bin/bash

set -e

if [ "$HADOOP_ROLE" == "STANDALONE" ]; then
  echo $HADOOP_ROLE && \
  cp -a /tmp/hadoop-standalone/* $HADOOP_CONF_DIR/
  if [ ! -f /data/hdfs/runonce.lock ]; then
    if [ ! -d /data/hdfs/namenode ]; then
      touch /data/hdfs/runonce.lock
      echo "NO DATA IN /data/hdfs/namenode"
      echo "FORMATTING NAMENODE"
      $HADOOP_PREFIX/bin/hdfs namenode -format || { echo 'FORMATTING FAILED' ; exit 1; }
      chown -R hduser:hadoop /data/hdfs || { echo 'CHOWN FAILED' ; exit 1; }
    fi
  fi

else
  if [ "$HADOOP_ROLE" == "MASTER" ]; then
    echo $HADOOP_ROLE
  elif [ "$HADOOP_ROLE" == "SLAVE" ]; then
    echo $HADOOP_ROLE
  elif [ "$HADOOP_ROLE" == "RESOURCEMANAGER" ]; then
    echo $HADOOP_ROLE
  elif [ "$HADOOP_ROLE" == "NODEMANAGER" ]; then
    echo $HADOOP_ROLE
  elif [ "$HADOOP_ROLE" == "NAMENODE1" ]; then
    echo $HADOOP_ROLE
  elif [ "$HADOOP_ROLE" == "NAMENODE2" ]; then
    echo $HADOOP_ROLE
  elif [ "$HADOOP_ROLE" == "JOURNALNODE" ]; then
    echo $HADOOP_ROLE
  elif [ "$HADOOP_ROLE" == "DATANODE" ]; then
    echo $HADOOP_ROLE
  elif [ "$HADOOP_ROLE" == "CLIENT" ]; then
    echo $HADOOP_ROLE
  elif [ "$HADOOP_ROLE" == "HTTPFS" ]; then
    echo $HADOOP_ROLE
  else
    echo "UNKNOWN ROLE. EXITING."
    exit 1
  fi
  echo Zookeeper Nodes: $HADOOP_ZOOKEEPER_CONNECT
  echo Hadoop NameNode1: $HADOOP_NAMENODE1
  echo Hadoop NameNode2: $HADOOP_NAMENODE2
  echo Hadoop ResourceManager: $HADOOP_RESOURCEMANAGER

  generate_config() {
    cat /tmp/hadoop-ha/$1 | sed \
        -e "s/@HADOOP_JOURNALNODE1@/$HADOOP_JOURNALNODE1/g" \
        -e "s/@HADOOP_JOURNALNODE2@/$HADOOP_JOURNALNODE2/g" \
        -e "s/@HADOOP_JOURNALNODE3@/$HADOOP_JOURNALNODE3/g" \
        -e "s/@HADOOP_CLUSTERNAME@/$HADOOP_CLUSTERNAME/g" \
        -e "s/@HADOOP_NAMENODE1@/$HADOOP_NAMENODE1/g" \
        -e "s/@HADOOP_NAMENODE2@/$HADOOP_NAMENODE2/g" \
        -e "s/@HADOOP_RESOURCEMANAGER1@/$HADOOP_RESOURCEMANAGER1/g" \
        -e "s/@HADOOP_RESOURCEMANAGER2@/$HADOOP_RESOURCEMANAGER2/g" \
        -e "s/@HADOOP_ZOOKEEPER_CONNECT@/$HADOOP_ZOOKEEPER_CONNECT/g" \
      > $HADOOP_CONF_DIR/$1
  }

  generate_config core-site.xml
  generate_config hadoop-env.sh
  generate_config hdfs-site.xml
  generate_config httpfs-site.xml
  generate_config mapred-site.xml
  generate_config yarn-site.xml


  if [ "$HADOOP_ROLE" == "NAMENODE1" ] ; then
    if [ ! -f /data/hdfs/runonce.lock ]; then
      if [ ! -d /data/hdfs/namenode ]; then
        touch /data/hdfs/runonce.lock
        echo "NO DATA IN /data/hdfs/namenode"
        echo "FORMATTING NAMENODE"
        $HADOOP_PREFIX/bin/hdfs namenode -format -clusterId $HADOOP_CLUSTERNAME || { echo 'FORMATTING FAILED' ; exit 1; }
        chown -R hduser:hadoop /data/hdfs || { echo 'CHOWN FAILED' ; exit 1; }
      fi
    fi
    export HADOOP_ROLE="NAMENODE"
  elif [ "$HADOOP_ROLE" == "NAMENODE2" ] ; then
    if [ ! -f /data/hdfs/runonce.lock ]; then
      if [ ! -d /data/hdfs/namenode ]; then
        touch /data/hdfs/runonce.lock
        echo "NO DATA IN /data/hdfs/namenode"
        echo "SYNCING DATA FROM NAMENODE1"
        sleep 10
        rsync -avh -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress $HADOOP_NAMENODE1:/data/hdfs/namenode /data/hdfs || { echo 'SYNC FAILED' ; exit 1; }
        chown -R hduser:hadoop /data/hdfs || { echo 'CHOWN FAILED' ; exit 1; }
      fi
    fi
    export HADOOP_ROLE="NAMENODE"
  elif [ "$HADOOP_ROLE" == "DATANODE" ] ; then
    if [ ! -f /data/hdfs/runonce.lock ]; then
      if [ ! -d /data/hdfs/datanode ]; then
        touch /data/hdfs/runonce.lock
        echo "NO DATA IN /data/hdfs/datanode"
        echo "CREATING DATANODE DIRECTORY"
        mkdir /data/hdfs/datanode || { echo 'DIRECTORY CREATION FAILED' ; exit 1; }
        chown -R hduser:hadoop /data/hdfs || { echo 'CHOWN FAILED' ; exit 1; }
      fi
    fi
  elif [ "$HADOOP_ROLE" == "JOURNALNODE" ]; then
    if [ ! -f /data/hdfs/runonce.lock ]; then
      if [ ! -d /data/hdfs/journalnode ]; then
        touch /data/hdfs/runonce.lock
        echo "NO DATA IN /data/hdfs/journalnode"
        echo "CREATING JOURNALNODE DIRECTORY"
        mkdir /data/hdfs/journalnode || { echo 'DIRECTORY CREATION FAILED' ; exit 1; }
        chown -R hduser:hadoop /data/hdfs || { echo 'CHOWN FAILED' ; exit 1; }
      fi
    fi
  fi
fi

rm -f /etc/supervisord.conf
cp /tmp/supervisord/$HADOOP_ROLE.conf /etc/supervisord.conf

exec $@
