import salt.utils.platform as os
import salt.modules.cmdmod as cmdmod

def __virtual__():
    if not os.is_windows():
        return False, 'Only available on Windows'
    return True

def __valid(dict, name):
    result = {}
    if type(dict) is not str:
        for key, value in dict.items():
            if name not in result.keys():
                result[name] = {}
            result[name][key] = value
    else:
        result[name] = dict

    return result

def get():
    need_install = __salt__['win_wua.available']()
    installed = __salt__['win_wua.installed']()

    need_install = __valid(need_install, 'available updates')
    installed = __valid(installed, 'installed update')

    return installed | need_install