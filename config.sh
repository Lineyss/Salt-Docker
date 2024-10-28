#!/bin/bash

CONFIG_FILE="/etc/salt/master"

sed -i "s/#state_events:.*/state_events: True/" $CONFIG_FILE

cat <<EOF >> $CONFIG_FILE
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
      - '@wheel'а
EOF

echo "salt:123321" | chpasswd