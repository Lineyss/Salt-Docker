from pymongo import MongoClient

class MongoDB:
    _instance = None
    db = None
    def __new__(cls, salt):
        if cls._instance is None:
           mongo_settings = salt['config.get']('mongo')
           host = mongo_settings['host']
           port = mongo_settings['port']
           db = mongo_settings['db']
           user = mongo_settings['user']
           password = mongo_settings['password']

           try:
               client = MongoClient(f'mongodb://{user}:{password}@{host}:{port}/{db}')
               cls.db = client[db]
           except Exception as e:
               print(f"Ошибка: Не удалось подключится к базе данных")

           cls._instance = super(MongoDB, cls).__new__(cls)

        return cls._instance

class MongoCollection():
    def __init__(self, collection_name, salt):
        mongoDb = MongoDB(salt)
        db = mongoDb.db

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