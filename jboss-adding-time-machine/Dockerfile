FROM jboss/wildfly:latest

LABEL vendor="SolutionSoft Systems, Inc"
LABEL maintainer="kzhao@solution-soft.com"

ENV PYTHON_VERSION=3.6 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

ENV LICHOST=172.0.0.1 \
    LICPORT=57777 \
    LICPASS=docker

ENV TM_VERSION=12.9R3 \
    TMAGENT_DATADIR=/tmdata/data \
    TMAGENT_LOGDIR=/tmdata/log

# User root user to install software
USER root

# - install supervisor and TM

RUN INSTALL_PKGS="rh-python36 rh-python36-python-devel rh-python36-python-setuptools rh-python36-python-pip nss_wrapper \
	libffi-devel libtool-ltdl" \
&&  yum -y update \
&&  yum install -y centos-release-scl \
&&  yum -y --setopt=tsflags=nodocs install --enablerepo=centosplus $INSTALL_PKGS \
&&  rpm -V $INSTALL_PKGS \
&&  source /opt/rh/rh-python36/enable \
&&  pip3 install supervisor \
&&  (cd /usr/bin; \
     ln -f -s /opt/rh/rh-python36/root/bin/supervisord .; \
     ln -f -s /opt/rh/rh-python36/root/bin/supervisorctl .; \
     ln -f -s /opt/rh/rh-python36/root/bin/echo_supervisord_conf .;) \
&&  mkdir -p /tmp/build \
&&  (cd /tmp/build; \
     curl -O ftp://ftp.solution-soft.com/pub/tm/linux/redhat/64bit/tm_linux_2.6.up_x86_64-$TM_VERSION.tgz; \
     tar -xzf tm_linux_2.6.up_x86_64-$TM_VERSION.tgz; \
     ./ssstm_install.sh tm_linux_2.6.up_x86_64-$TM_VERSION.rpm; \
     yum history sync) \
&&  yum -y clean all --enablerepo='*' \
&&  rm -rf /tmp/build \
&&  mkdir -p /tmdata

# - install tmlicd

COPY bin/tmlicd /usr/local/bin

# - install supervisord config files

COPY config /

EXPOSE 7800
VOLUME /tmdata

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
