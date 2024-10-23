db = db.getSiblingDB('salt_db');

db.createUser({
    user: "salt",
    pwd: "123321",
    roles: [{ role: "readWrite", db: "salt_db" }]
});