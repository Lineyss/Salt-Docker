FROM ubuntu:latest

RUN apt-get update \
  && apt-get -y install passwd \
  && apt-get -y install nano \
  && apt-get -y install supervisor
  
COPY configs/supervisord /etc/supervisord/conf.d

ADD https://bootstrap.saltproject.io/bootstrap-salt.sh /bootstrap-salt.sh
RUN chmod +x bootstrap-salt.sh
RUN ./bootstrap-salt.sh -M -N -X

RUN apt-get update \
  && apt-get -y install salt-api

COPY config.sh ./
RUN chmod +x ./config.sh \
  && ./config.sh

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord/conf.d/supervisord.conf"]

RUN salt-pip install pymongo