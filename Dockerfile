FROM zenchicken/jenkins-codepipeline

MAINTAINER jsh@digitalmaelstrom.net

ENV PHANTOMJS_VERSION 1.9.8
USER root
RUN \
  apt-get update && \
  apt-get upgrade  -y && \
  apt-get install  -y nodejs npm vim git wget libfreetype6 libfontconfig bzip2 awscli && \

  mkdir -p /srv/var && \
  wget -q --no-check-certificate -O /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  tar -xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp && \
  rm -f /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/ /srv/var/phantomjs && \
  ln -s /srv/var/phantomjs/bin/phantomjs /usr/bin/phantomjs && \
  git clone https://github.com/n1k0/casperjs.git /srv/var/casperjs && \
  ln -s /srv/var/casperjs/bin/casperjs /usr/bin/casperjs && \
  apt-get autoremove -y && \
  apt-get clean all && \
  ln -s /usr/bin/nodejs /usr/bin/node
RUN /usr/sbin/groupmod -g 497 docker && /usr/sbin/usermod -g docker jenkins

USER root
RUN \
    command curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -sSL https://get.rvm.io | /bin/bash -s stable --without-gems="rvm rubygems-bundler" --ruby=2.2.1
RUN \
    /bin/bash -l -c "source /usr/local/rvm/scripts/rvm" && \
    /bin/bash -l -c "rvm user gemsets" && \
    /bin/bash -l -c "gem install bundler" && \
    /bin/bash -l -c "source /etc/profile" && \
    /bin/bash -l -c "mkdir /var/lib/gems" && \
    /bin/bash -l -c "chmod 757 /var/lib/gems" && \
    apt-get install -y libffi-dev && \
    npm install gulp -g


USER jenkins
RUN \
    /bin/bash -l -c "source /etc/profile" && \
    /bin/bash -l -c "rvm user gemsets"


# Use Jenkins container default endpoint
