from mongo.minionInfo import MinionInfo
from mongo.minionConnect import MinionConnect

def get_collection():
    return MinionInfo(__salt__)

def save(info, minion_id):
    minionInfo = get_collection()
    return minionInfo.update_info({minion_id: info})

def get():
    minionInfo = get_collection()
    return minionInfo.get()
