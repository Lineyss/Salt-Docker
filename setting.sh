#!bin/bash

sed -i "s/#state_events:.*/state_events: True/" "/etc/salt/master"

echo "salt:123321" | chpasswd 

# salt-run saltutil.sync_all

# curl -I https://repo.saltproject.io/salt/py3/ubuntu/24.04/amd64/latest/SALT-PROJECT-GPG-PUBKEY-2023.gpg

# chmod +X bootstrap-salt.sh
# bash bootstrap-salt.sh -M -N
# # apt-get update \
# #     && apt-get install -y salt-common \
# #     && apt-get install -y salt-master \
# #     && apt-get install -y salt-api \
# #     && salt-pip install --upgrade pip \
# #     && salt-pip install pygit2 \
# #     && salt-pip install python-ldap \
# #     && salt-pip install pymongo