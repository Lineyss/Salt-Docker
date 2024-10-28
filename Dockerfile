FROM ubuntu:latest

ENV PUBLISH_PORT=4505
ENV RET_PORT=4506
ENV USER=salt

RUN apt-get update \
  && apt-get -y install passwd \
  && apt-get -y install nano \
  && apt-get -y install supervisor

ADD https://bootstrap.saltproject.io/bootstrap-salt.sh /bootstrap-salt.sh
RUN chmod +x bootstrap-salt.sh
RUN ./bootstrap-salt.sh -M -N -X

RUN apt-get update \
  && apt-get -y install salt-api

WORKDIR /scripts
COPY scripts /scripts
RUN chmod +x /scripts/set_config.sh
RUN ./set_config.sh

COPY configs/supervisord /etc/supervisord/conf.d

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord/conf.d/supervisord.conf"]

RUN salt-pip install pymongo