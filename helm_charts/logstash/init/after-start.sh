#!/usr/bin/env bash

cd /tmp
wget http://www.dbschema.com/jdbc-drivers/MongoDbJdbcDriver.zip
unzip MongoDbJdbcDriver.zip

/usr/share/logstash/bin/logstash-plugin install logstash-output-mongodb