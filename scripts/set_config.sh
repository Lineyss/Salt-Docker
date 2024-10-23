#!/bin/bash

CONFIG_FILE="/etc/salt/master"

cat <<EOF >> $CONFIG_FILE
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

echo "$USER:123321" | chpasswd