FROM ubuntu:latest

ADD https://bootstrap.saltproject.io/bootstrap-salt.sh /bootstrap-salt.sh
RUN chmod +x bootstrap-salt.sh
RUN ./bootstrap-salt.sh -M -N -X

RUN apt-get update \
  && apt-get -y install passwd \
  && apt-get -y install nano \
  && apt-get -y install supervisor \
  && apt-get -y install salt-api \
  && salt-pip install pymongo

COPY setting.sh ..
RUN chmod +x /setting.sh
RUN ./srv/setting.sh

COPY configs/supervisord /etc/supervisord/conf.d
COPY configs/master /etc/salt/master.d
COPY srv /srv

EXPOSE 4505 4506 8000
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord/conf.d/supervisord.conf"]