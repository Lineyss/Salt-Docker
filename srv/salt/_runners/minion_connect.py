from mongo.minionConnect import MinionConnect

def change_status_minion(online, offline):
    minionConnect = MinionConnect(__salt__)
    return minionConnect.change_status_minion(online, offline)

def get():
    minionConnect = MinionConnect(__salt__)
    return minionConnect.get()