import os

if os.name == 'nt':
   import winreg

class Programs(): 
    def __init__(self, display_name, publisher, uninstall_string, quiet_uninstall_string, display_icon, display_version) -> None:
        self.publisher = publisher
        self.display_name = display_name
        self.display_icon = display_icon
        self.display_version = display_version
        self.uninstall_string = uninstall_string
        self.quiet_uninstall_string = quiet_uninstall_string

    def to_dict(self):
        return {
                "display_name": self.display_name,
                "publisher": self.publisher,
                "uninstall_string": self.uninstall_string,
                "quiet_uninstall_string": self.quiet_uninstall_string,
                "display_icon": self.display_icon,
                "display_version": self.display_version
            }

class RegistrySoftwareFinder():     
    def __init__(self) -> None:
        self.dirs = [
            winreg.HKEY_LOCAL_MACHINE,
            winreg.HKEY_CURRENT_USER,
            winreg.HKEY_USERS
        ]

        self.keys = [
            r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
            r"SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        ]

    def find(self):
        softwares = set()

        for dir in self.dirs:
            for key in self.keys:
                programs = self.read_programs_from_registry(dir, key)
                softwares.update(programs)
        return softwares

    def read_programs_from_registry(self, base_key, sub_key_path):
        programs = set()
        try:
            aReg = winreg.ConnectRegistry(None, base_key)
            aKey = winreg.OpenKey(aReg, sub_key_path)
            for i in range(winreg.QueryInfoKey(aKey)[0]):
                try:
                    sub_key_name = winreg.EnumKey(aKey, i)
                    new_sub_key_path = rf'{sub_key_path}\{sub_key_name}'
                    software = self.get_software_from_key(base_key, new_sub_key_path)
                    print(software)
                    if software:
                        programs.add(software)
                except Exception:
                    pass
        except FileNotFoundError:
            pass

        return programs
    
    def get_software_from_key(self, base_key, sub_key_name):
        try:
            registry_key = winreg.OpenKey(base_key, sub_key_name)
            display_name = self.safe_query_value(registry_key, "DisplayName")
            display_name = self.safe_query_value(registry_key, "DisplayName")
            publisher = self.safe_query_value(registry_key, "Publisher")
            uninstall_string = self.safe_query_value(registry_key, "UninstallString")
            quiet_uninstall_string = self.safe_query_value(registry_key, "QuietUninstallString")
            display_icon = self.safe_query_value(registry_key, "DisplayIcon")
            display_version = self.safe_query_value(registry_key, "DisplayVersion")

            if display_name:
                return Programs(display_name, publisher, uninstall_string, quiet_uninstall_string, display_icon, display_version)

        except Exception as e:
            print(f"Ошибка в get_software_from_key: {e}")

        return None

    def safe_query_value(self, program_key, value_name):
        try:
            return winreg.QueryValueEx(program_key, value_name)[0]
        except Exception:
            return None

def _rsf():
    """
    Ищет установленные ПО в реестре window
    :return: массив класса Programs в виде json
    """
    if __grains__['os'] is 'Windows':
        registrySoftwareFinder = RegistrySoftwareFinder()
        softwares = registrySoftwareFinder.find()
        a = [software.to_dict() for software in softwares]
        return a

    return ''

def info():
    if __grains__['os'] is 'Windows':
       return {'softwares': _rsf()}
    else:
       return __salt__['pkg.list_pkgs']()

def valid(dict, name):
    result = {}
    for key, value in dict.items():
        result[key] = {name: value}
    return result