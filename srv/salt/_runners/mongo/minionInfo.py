from .mongodb import *

class MinionInfo(MongoCollection):
    collection_name = 'minionsInfo'

    def __init__(self, salt):
        super().__init__(self.collection_name, salt)

    def update_info(self, minion):
        key = list(minion.keys())[0]
        self.collection.update_one(
             {'key': key},
             {'$set': minion},
             upsert=True
        )
        return minion