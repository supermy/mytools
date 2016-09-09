# alpine-mysql
a docker image base on alpine with mysql

# build image
```
docker build -t supermy/ap-mysql .
docker run -it --rm -v $(pwd):/app -p 3306:3306 supermy/ap-mysql
```

# Usage
```
docker run -it --name mysql -p 3306:3306 -v $(pwd):/app -e MYSQL_DATABASE=admin -e MYSQL_USER=jamesmo -e MYSQL_PASSWORD=123456 -e MYSQL_ROOT_PASSWORD=111111 supermy/ap-mysql
```

It will create a new db, and set mysql root password(default is 111111)