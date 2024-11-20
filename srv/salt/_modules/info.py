import salt.utils.platform as os

delete_keys = ['ipv6', 'ipv4', 'fqdn_ip4', 'fqdn_ip6']
merge_keys = ['ip4_interfaces', 'ip_interfaces', 'ip6_interfaces']

def _delete_key(key, dict):
    del dict[key]

def _merge_key(dict):
    merge_interfaces = {}
    for key in merge_keys:
        if key in dict:
           for interface, addresses in dict[key].items():
               if interface not in merge_interfaces:
                  merge_interfaces[interface] = addresses
        _delete_key(key, dict)
    return merge_interfaces

def get():
    software = __salt__['software.get']()
    info = __salt__['grains.items']()

    for key in delete_keys:
        if key in info:
           _delete_key(key, info)

    merge_interfaces = _merge_key(info)
    info['ip_interfaces'] = merge_interfaces

    result = info | software

    if os.is_windows():
        return result | __salt__['win_upd.get']()

    return result