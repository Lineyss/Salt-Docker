from pymongo import MongoClient
from datetime import datetime

class MongoDB:
    _instance = None
    _db = None
    
    def __new__(cls, salt):
        if cls._instance is None:
            mongo_settings = salt['config.get']('mongo')
            host = mongo_settings['host']
            port = mongo_settings['port']
            db_name = mongo_settings['db']
            user = mongo_settings['root_user']
            password = mongo_settings['root_password']

            client = MongoClient(f'mongodb://{user}:{password}@{host}:{port}/')
            db = client[db_name]

            if db_name not in client.list_database_names():
                collection = db['init']
                collection.insert_one({
                    'created': datetime.now().__str__()
                })

                user = mongo_settings['user_db']
                password = mongo_settings['password_db']

                roles = [
                    {
                        "role": "dbOwner", 
                        "db": f"db_name"
                    }
                ]

                db.command("createUser", user, pwd=password, roles=roles)

            cls._db = db
            cls._instance = super(MongoDB, cls).__new__(cls)

        return cls._instance

class MongoCollection():
    def __init__(self, collection_name, salt):
        mongoDb = MongoDB(salt)
        db = mongoDb._db
        if collection_name not in db.list_collection_names():
           db.create_collection(collection_name)

        self.collection = db[collection_name]

    def convert_result(self, minions):
        result = []
        for minion in minions:
            minion.pop('_id')
            result.append(minion)
        return result

    def get(self):
        minions = self.collection.find()
        return self.convert_result(minions)
