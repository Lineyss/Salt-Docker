from ubuntu:latest

RUN apt-get update \
&& apt-get install -y init \
&& apt-get install systemd \
&& apt-get install -y curl \
&& apt-get install -y nano \
&& apt-get install -y git \
&& apt-get install -y sudo \
&& apt-get install -y inotify-tools \
&& apt-get clean all \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | tee /etc/apt/keyrings/salt-archive-keyring.pgp
RUN curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | tee /etc/apt/sources.list.d/salt.sources

RUN echo 'Package: salt-* Pin: version 3007.* Pin-Priority: 1001' | tee /etc/apt/preferences.d/salt-pin-1001

RUN apt-get update \
    && apt-get install -y salt-master \
    && apt-get install -y salt-api \
    && apt-get install -y salt-common \
    && salt-pip install pygit \
    && salt-pip install pymongo

COPY master /etc/salt/master.d
COPY srv /srv

RUN echo "salt:123321" | chpasswd

RUN salt-pip install pip==22.3.1
RUN salt-pip install pygit2==1.14.1
RUN salt-pip install python-ldap

ENTRYPOINT ["systemd"]
CMD ["./setting.sh"]