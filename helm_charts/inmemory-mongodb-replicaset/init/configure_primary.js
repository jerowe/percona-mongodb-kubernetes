rs.initiate({
    "_id": "rs0",
    "settings": {"replicasetId": ObjectId("5e7c69ccf58de34d19431911")},
    "writeConcernMajorityJournalDefault": false,
    "members": [{
        "_id": 0,
        "host": "mongodb-mongodb-replicaset-0.mongodb-mongodb-replicaset.default.svc.cluster.local:27017"
    }]
})

// cfg = rs.conf()
// cfg.settings.replicaSetId = ObjectId("5e7c69ccf58de34d19431911")
// rs.reconfig(cfg, {force: true})
