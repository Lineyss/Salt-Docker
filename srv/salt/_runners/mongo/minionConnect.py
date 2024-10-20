from .mongodb import *

class MinionConnect(MongoCollection):
    collection_connect_info_name = 'minionsConnect'

    def __init__(self, salt):
        super().__init__(self.collection_connect_info_name, salt)

    def update_status(self, minions, status):
        result = []
        for minion_id in minions:
            value = {'minion_id': minion_id, 'status': status}
            result_value = {minion_id: status}
            self.collection.update_one(
                {'key': minion_id},
                {'$set': value},
                upsert=True
            )
            result.append(result_value)
        return result

    def change_status_minion(self, online, offline):
        result = []

        online = self.update_status(online, 'online')
        offline = self.update_status(offline, 'offline')

        result = online + offline

        return result