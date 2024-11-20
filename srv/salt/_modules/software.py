import salt.utils.platform as os

if os.is_windows():
   from win_programs.programs import RegistrySoftwareFinder

def __rsf():
    if os.is_windows():
        registrySoftwareFinder = RegistrySoftwareFinder()
        softwares = registrySoftwareFinder.find()
        a = [software.to_dict() for software in softwares]
        return a

    return 'The method is available only Windows'

def get():
    if os.is_windows():
       return {'softwares': __rsf()}
    else:
       return {'softwares': __salt__['pkg.list_pkgs']()}