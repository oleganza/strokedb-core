require 'strokedb-core'
include StrokeDB::Core


db = Repository.open("documents.db")

oleg_uuid = db.post({"proto" => "User", "name" => "oleg"})
doc = db.get(oleg_uuid)

doc["age"] = 21
db.put(oleg_uuid, doc)

db.close









