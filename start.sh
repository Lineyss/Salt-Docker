#!/bin/bash

CONFIG_MASTER="/etc/salt/master"
CONFIG_SUPERVISORD="/etc/supervisord/conf"

sed -i "s/#state_events:.*/state_events: True/" $CONFIG_MASTER
sed -i "s|^user=.*|user=salt|" "${CONFIG_SUPERVISORD}"

cat <<EOF >> $CONFIG_MASTER
presence_events: True

rest_cherrypy:
  port: 8080
  debug: True
  disable_ssl: True

netapi_enable_clients:
  - local
  - runner

external_auth:
  pam:
    salt:
      - .*
      - '@runner'
      - '@wheel'
EOF

echo "salt:123321" | chpasswd

supervisorctl reread
supervisorctl update

supervisorctl start salt-master | salt-api
# /usr/bin/supervisord -c /etc/supervisord/conf.d/supervisord.conf