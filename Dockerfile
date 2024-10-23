FROM ubuntu:latest

ENV PUBLISH_PORT=4505
ENV RET_PORT=4506
ENV USER=salt
ENV USER_PASSWORD=123321

RUN apt-get update \
    && apt-get -y install curl \
    && apt-get -y install passwd \
    && apt-get -y install nano \
    && apt-get install -y supervisor

RUN curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
RUN chmod +x bootstrap-salt.sh
RUN ./bootstrap-salt.sh -M -N -X

RUN apt-get update \
  && apt-get -y install salt-api

RUN echo "$USER:$USER_PASSWORD" | chpasswd

COPY configs/salt /etc/salt/master.d
COPY configs/supervisord /etc/supervisord/conf.d

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord/conf.d/supervisord.conf"]

RUN salt-run saltutil.sync_all