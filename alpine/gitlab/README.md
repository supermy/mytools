2017-01-07
    支持docker 命令运行  ok
    docker run --detach \
        --publish 443:443 --publish 1080:80 --publish 22:22 \
        --name gitlab \
        --restart always \
        --volume ce-etc:/etc/gitlab \
        --volume ce-log:/var/log/gitlab \
        --volume ce-data:/var/opt/gitlab \
        beginor/gitlab-ce:8.15.1-ce.0
        
    docker exec -it gitlab update-permissions
    docker restart gitlab
    
    http://127.0.0.1:10080/dashboard/milestones?state=all
    
    通过代理获取数据失败，git clone --progress --verbose https://gitlab.com/xhang/gitlab.git 
        
        
2017-01-04
    新版安装:厂家社区docker 版本
    docker pull gitlab/gitlab-ce
    docker build -t supermy/ap-gitlab  gitlab
    
docker run \
    --detach \
    --publish 8443:443 \
    --publish 8080:80 \
    --name gitlab \
    --restart unless-stopped \
    --volume /mnt/sda1/gitlab/etc:/etc/gitlab \
    --volume /mnt/sda1/gitlab/log:/var/log/gitlab \
    --volume /mnt/sda1/gitlab/data:/var/opt/gitlab \
    beginor/gitlab-ce
    
    大版本升级用 docker exec ， 也可以用 ssh ， 依次执行下面的命令：
    gitlab-ctl reconfigure
    gitlab-ctl restart
    
    http://127.0.0.1:10080/
    升级镜像到8.15版本
    启动的时候确认本机mysql and redis 的ip 地址是否更新；
    最新的GitLab 8.15版提供了新的持续集成和持续部署（CI/CD）特性，目的在于自动化不同平台上的部署，并使用命令行界面让试机（Staging）或产品部署更加便捷。
