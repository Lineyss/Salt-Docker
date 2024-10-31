import os

def valid(dict, name):
    result = {}
    for key, value in dict.items():
        if name not in result.keys():
            result[name] = {}
        result[name][key] = value
    return result

def get():
    if os.name != 'nt':
        return 'Method for windows'
    
    need_install = __salt__['win_wua.list']()
    installed = __salt__['win_wua.installed']()

    need_install = valid(need_install, 'available updates')
    installed = valid(installed, 'installed update')
    
    return installed | need_install
