# Results

I ran tests installing, adding data, deleting, reinstalling, and then running a count to make sure that the data persists.

## Official MongoDB 4.0

```
#######################################################
# Testing MongoDB with Official Mongo image
#######################################################
#######################################################
# Getting COUNT BEFORE
MongoDB shell version v4.0.17
connecting to: mongodb://127.0.0.1:27017/test?authSource=admin&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("5437609c-6695-41a4-84c7-56bcdf9a5c9c") }
MongoDB server version: 4.0.17
10000
#######################################################
# Getting COUNT AFTER
MongoDB shell version v4.0.17
connecting to: mongodb://127.0.0.1:27017/test?authSource=admin&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("97147bb0-7891-4765-bc2d-aded573b7e3c") }
MongoDB server version: 4.0.17
10000
```

## Percona with WiredTiger 4.2

```
#######################################################
# Testing MongoDB with Percona Mongo and Wired Tiger
#######################################################
#######################################################
# Getting COUNT BEFORE
Percona Server for MongoDB shell version v4.2.3-4
connecting to: mongodb://127.0.0.1:27017/test?authSource=admin&compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("7e7aa06a-4f28-4d58-adce-5d2471456613") }
Percona Server for MongoDB server version: v4.2.3-4
10000
#######################################################
#######################################################
# Getting COUNT AFTER
Percona Server for MongoDB shell version v4.2.3-4
connecting to: mongodb://127.0.0.1:27017/test?authSource=admin&compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("43f529f3-332b-47be-a8e5-7fc1657ddbd9") }
Percona Server for MongoDB server version: v4.2.3-4
10000
#######################################################
```

## Percona with 2 InMemory and 3rd WiredTiger