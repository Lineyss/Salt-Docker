def __virtual__():
    if __grains__['os'] is not 'Windows':
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
    need_install = __salt__['win_wua.list']()
    installed = __salt__['win_wua.installed']()

    need_install = valid(need_install, 'available updates')
    installed = valid(installed, 'installed update')
    
    return installed | need_install

def install(update):
    result = __salt__['win_wua.download'](names=[update])

    if result['Success']:
        result = __salt__['win_wua.install'](names=[update])
    
    return result
