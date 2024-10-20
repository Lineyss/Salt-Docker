FROM ubuntu:latest

ENV PUBLISH_PORT=4505
ENV RET_PORT=4506
ENV USER=docker_salt
ENV USER_PASSWORD=123321

RUN apt-get update \
    && apt-get -y install curl \
    && apt-get -y install passwd

RUN useradd -m -s /bin/bash $USER \
    && echo "$USER:$USER_PASSWORD" | chpasswd

RUN curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
RUN chmod +x bootstrap-salt.sh

RUN ./bootstrap-salt.sh -M -N -W -X

COPY srv /srv
COPY configs /etc/salt/master.d

ENTRYPOINT ["salt-master"]

RUN salt-run saltutil.sync_all