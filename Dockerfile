FROM ubuntu:latest

RUN apt-get update \
  && apt-get -y install passwd \
  && apt-get -y install nano \
  && apt-get -y install git \
  && apt-get -y install supervisor \
  
ADD https://bootstrap.saltproject.io/bootstrap-salt.sh /bootstrap-salt.sh
RUN chmod +x bootstrap-salt.sh
RUN ./bootstrap-salt.sh -M -N -X

RUN salt-pip install pymongo

RUN apt-get update \
  && apt-get -y install salt-api

COPY configs/supervisord /etc/supervisord/conf.d
COPY configs/master /etc/salt/master.d
COPY srv /srv
COPY config.sh ./config.sh
RUN chmod +x ./config.sh
RUN ./config.sh

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord/conf.d/supervisord.conf"]