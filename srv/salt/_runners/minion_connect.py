from mongo.minionConnect import MinionConnect

def change_status_minion(online=None, offline=None):
    minionConnect = MinionConnect(__salt__)
    return minionConnect.change_status_minion(online, offline)

def get():
    minionConnect = MinionConnect(__salt__)
    return minionConnect.get()
