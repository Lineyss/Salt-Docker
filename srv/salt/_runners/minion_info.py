from mongo.minionInfo import MinionInfo

def save(info, minion_id):
    minionInfo = MinionInfo(__salt__)
    return minionInfo.update_info({minion_id: info})

def get():
    minionInfo = MinionInfo(__salt__)
    return minionInfo.get()
