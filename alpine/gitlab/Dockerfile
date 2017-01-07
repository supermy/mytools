FROM gitlab/gitlab-ce

MAINTAINER JamesMo <springclick@gmail.com>

ENV TMPDIR=/tmp/gitlab-zh
ENV GITLAB_VERSION=v8.15.2

# clone && apply zh patch.
RUN git config --global http.sslVerify false && git config --global http.postBuffer 524288000 && \
    git clone --progress --verbose https://gitlab.com/xhang/gitlab.git $TMPDIR && \
    cd $TMPDIR && \
    git diff $GITLAB_VERSION..$GITLAB_VERSION-zh > $TMPDIR/$GITLAB_VERSION-zh.diff && \
    cd /opt/gitlab/embedded/service/gitlab-rails && git apply $TMPDIR/$GITLAB_VERSION-zh.diff
     #&& \ rm -rf $TMPDIR

# Expose web & ssh
EXPOSE 443 80 22

# Define data volumes
VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]
# Wrapper to handle signal, trigger runit and reconfigure GitLab
CMD ["/assets/wrapper"]