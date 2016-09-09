### Usage

Some indications:

* Tomcat installation directory is `/opt/tomcat` (`$TOMCAT_HOME`/`$CATALINA_HOME`). Executable scripts are found in directory `$TOMCAT_HOME/bin` and the application base (*appBase*) directory is `$TOMCAT_HOME/webapps`.
* The path of file `catalina.out` is managed by the variable `$CATALINA_OUT`, and its value by default is `/dev/null` (disabled).
* Apache logs are written into directory `/logs/`.

There are two ways to use this image:

1. Use it as base image for other images. For example:

  ```
  FROM supermy/ap-tomcat
  ```

1. Use the image directly, and copy the `.war` files directly into the *appBase* directory. For example:

  ```
  to fix: 暂时不能使用......
  docker run -it --rm -P supermy/ap-tomcat /opt/tomcat/bin/catalina.sh run
  docker run -it --rm -P supermy/ap-tomcat-cluster

  docker cp ./sample.war tomcat-ci:/opt/tomcat/webapps/sample.war
  ```