# # FROM ubuntu:latest

# # ENV PUBLISH_PORT=4505
# # ENV RET_PORT=4506
# # ENV USER=salt
# # ENV USER_PASSWORD=123321


# # RUN chmod +x bootstrap-salt.sh
# # RUN ./bootstrap-salt.sh -M -N

# # RUN apt-get update \
# #     && apt-get -y install salt-api

# # COPY srv /srv
# # COPY configs/salt /etc/salt/master.d

# # WORKDIR scripts
# # COPY scripts ./
# # RUN chmod +x *
# # RUN ./set_config_setting.sh

# # ENTRYPOINT ['sh', '-c', 'salt-master&salt-api']

# # CMD ["salt-run saltutil.sync_all"]

# FROM ubuntu:22.04
# LABEL maintainer="Enio Carboni"

# ARG DEBIAN_FRONTEND=noninteractive

# RUN apt-get update \
#     && apt-get install -y --no-install-recommends \
#     software-properties-common \
#     rsyslog systemd systemd-cron sudo \
#     && apt-get clean \
#     && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
#     && rm -rf /var/lib/apt/lists/* \
#     && touch -d "2 hours ago" /var/lib/apt/lists/ \
#     && apt-get -y install curl \
#     && apt-get -y install passwd \
#     && apt-get -y install nano

# RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# RUN rm -f /lib/systemd/system/systemd*udev* \
#     && rm -f /lib/systemd/system/getty.target

# # RUN chmod +x bootstrap-salt.sh
# # RUN ./bootstrap-salt.sh -M -N

# VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
# CMD ["/lib/systemd/systemd"]

FROM ubuntu:22.04
LABEL maintainer="Enio Carboni"

ARG DEBIAN_FRONTEND=noninteractive

# Install: dependencies, clean: apt cache, remove dir: cache, man, doc, change mod time of cache dir.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       software-properties-common \
       rsyslog systemd systemd-cron sudo \
    && apt-get clean \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && rm -rf /var/lib/apt/lists/* \
    && touch -d "2 hours ago" /var/lib/apt/lists

RUN apt-get update \
    && apt-get -y --no-install-recommends install curl \
    && apt-get -y --no-install-recommends install passwd \
    && apt-get -y --no-install-recommends install nano

RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

RUN rm -f /lib/systemd/system/systemd*udev* \
  && rm -f /lib/systemd/system/getty.target

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]

