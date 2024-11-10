import salt.modules.cmdmod as cmdmod

def __virtual__():
    if __grains__['os'] not in ['Windows']:
        return False, 'Unsupported os'
    return True

def valid(dict, name):
    result = {}
    for key, value in dict.items():
        if name not in result.keys():
            result[name] = {}
        result[name][key] = value
    return result

def get():
    need_install = __salt__['win_wua.available']()
    installed = __salt__['win_wua.installed']()

    need_install = valid(need_install, 'available updates')
    installed = valid(installed, 'installed update')
    
    return installed | need_install

def uninstall(KB):
    result = cmdmod.run(f'wusa /uninstall /kb:{KB}')
    return result