db = db.getSiblingDB('admin');
db.auth("root", "root");
db = db.getSiblingDB('salt_db');

db.createUser(
    {
        user: "salt",
        pwd: "123321",
        roles: [
            {
                role: "dbOwner",
                db: "salt_db"
            }
        ]
    }
);

db.createCollection('init');