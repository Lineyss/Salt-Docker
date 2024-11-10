#!bin/bash
sed -i "s/#state_events:.*/state_events: True/" "/etc/salt/master"

echo "salt:123321" | chpasswd 