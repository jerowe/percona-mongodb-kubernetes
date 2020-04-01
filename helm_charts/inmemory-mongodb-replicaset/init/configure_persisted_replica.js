//This script assumes that there are 3 replicas
// and that the 3rd persists to disk

cfg = rs.conf()
cfg.members[2].priority = 1
cfg.members[2].hidden = false
// cfg.settings.replicaSetId = ObjectId("5e7c69ccf58de34d19431911")
rs.reconfig(cfg, {force: true})
rs.add({
    "host": "mongodb-mongodb-replicaset-2.mongodb-mongodb-replicaset.default.svc.cluster.local:27017",
    "_id": 2,
    hidden:  false,
    priority: 1
})
// cfg = rs.conf()
// rs.reconfig(cfg, {force: true})
