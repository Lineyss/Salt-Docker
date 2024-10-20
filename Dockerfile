FROM ubuntu:latest

RUN apt-get update \
    && apt-get -y install curl

RUN curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
RUN chmod +x bootstrap-salt.sh

RUN ./bootstrap-salt.sh -M -N -W -q -X

COPY srv /srv

ENTRYPOINT ["salt-master"]