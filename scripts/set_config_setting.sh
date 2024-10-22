#!/bin/bash

CONFIG_FILE="/etc/salt/master"

# sed -i "s/user: salt/user: $USER/" $CONFIG_FILE
sed -i "s/#publish_port:.*/publish_port: $PUBLISH_PORT/" $CONFIG_FILE
sed -i "s/#ret_port:.*/ret_port: $RET_PORT/" $CONFIG_FILE

# if id "$USER" >/dev/null; then
#    echo ""
# else
#    useradd -m "$USER"
#    usermod -aG sudo "$USER"
# fi

echo "$USER:$USER_PASSWORD" | chpasswd