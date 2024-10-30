FROM ubuntu:latest

RUN apt-get update \
  && apt-get -y install passwd \
  && apt-get -y install nano \
  && apt-get -y install git \
  && apt-get -y install supervisor
  
ADD https://bootstrap.saltproject.io/bootstrap-salt.sh /bootstrap-salt.sh
RUN chmod +x bootstrap-salt.sh
RUN ./bootstrap-salt.sh -M -N -X

RUN salt-pip install pymongo

RUN apt-get update \
  && apt-get -y install salt-api

COPY start.sh ./srv/start.sh
RUN chmod +x ./srv/start.sh

COPY configs/supervisord /etc/supervisord/conf.d
COPY configs/master /etc/salt/master.d
COPY srv /srv

EXPOSE 4505 4506 8000

# ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord/conf.d/supervisord.conf"]
ENTRYPOINT ["./srv/start.sh"]