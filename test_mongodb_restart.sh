#!/usr/bin/env bash
#!/usr/bin/env bash

############################################
# DO NOT RUN ON A PRODUCTION INSTANCE
# This script is to test that the mongodb cluster can be restarted
# and persist data
############################################

# Startup the dev cluster
#./startup-dev-cluster.sh
#sleep 120

cleanup(){
    helm delete mongodb  > /dev/null 2>&1

    kubectl delete pvc datadir-mongodb-mongodb-replicaset-0  > /dev/null 2>&1
    kubectl delete pvc datadir-mongodb-mongodb-replicaset-1  > /dev/null 2>&1
    kubectl delete pvc datadir-mongodb-mongodb-replicaset-2  > /dev/null 2>&1

    kubectl delete pvc inmemorydatadir-mongodb-mongodb-replicaset-0  > /dev/null 2>&1
    kubectl delete pvc inmemorydatadir-mongodb-mongodb-replicaset-1  > /dev/null 2>&1
    kubectl delete pvc inmemorydatadir-mongodb-mongodb-replicaset-2  > /dev/null 2>&1
}

add_data_to_mongodb(){
    CWD=$(pwd)

    # Get mgodatagen for generating random data
    cd /tmp
    wget https://github.com/feliixx/mgodatagen/releases/download/0.7.5/mgodatagen_linux_x86_64.tar.gz > /dev/null 2>&1
    tar -xvf mgodatagen_linux_x86_64.tar.gz > /dev/null 2>&1

    kubectl cp mgodatagen mongodb-mongodb-replicaset-0:/data/db

    cd ${CWD}
    kubectl cp --container mongodb-replicaset config-test.json mongodb-mongodb-replicaset-0:/data/db > /dev/null 2>&1
    kubectl exec -it --container mongodb-replicaset mongodb-mongodb-replicaset-0 chmod 777 /data/db/mgodatagen > /dev/null 2>&1

    # Add in random data
    kubectl exec -it --container mongodb-replicaset mongodb-mongodb-replicaset-0 -- /data/db/mgodatagen -f /data/db/config-test.json -u username -p password -h mongodb-mongodb-replicaset > /dev/null 2>&1
}

get_before_count(){
    # Get the count
    echo "#######################################################"
    echo "# Getting COUNT BEFORE"
    kubectl exec -it --container mongodb-replicaset mongodb-mongodb-replicaset-0 -- mongo test --authenticationDatabase admin -u username -p password  --eval "db.collection.count()"
    echo "#######################################################"
}

get_after_count(){
    # Get the count (Should be the same as previously - NOT 0)
    echo "#######################################################"
    echo "# Getting COUNT AFTER"
    kubectl exec -it --container mongodb-replicaset mongodb-mongodb-replicaset-0 -- mongo test --authenticationDatabase admin -u username -p password  --eval "db.collection.count()"
    echo "#######################################################"
}

delete_mongo_release() {
    # Give the data time to percolate
    helm delete mongodb
}

startup(){
    local values="${1}"
    helm upgrade --install \
        mongodb \
        stable/mongodb-replicaset \
        --values ${values}  > /dev/null 2>&1
    sleep 120
}

helm repo add stable https://kubernetes-charts.storage.googleapis.com

cleanup

echo "#######################################################"
echo "# Testing MongoDB with Official Mongo image"
echo "#######################################################"
startup helm_charts/orig-mongodb-replicaset/values.yaml
add_data_to_mongodb
get_before_count
get_after_count
cleanup

echo "#######################################################"
echo "# Testing MongoDB with Percona Mongo and Wired Tiger"
echo "#######################################################"
startup helm_charts/percona-wiredtiger-mongodb-replicaset/values.yaml
add_data_to_mongodb
get_before_count
get_after_count
cleanup

echo "#######################################################"
echo "# Testing MongoDB with Percona Mongo"
echo "# 2 Replicas InMemory and 3rd Persisted"
echo "#######################################################"
 helm upgrade --install \
    mongodb \
    helm_charts/mongodb-replicaset
sleep 120
add_data_to_mongodb
get_before_count
get_after_count
cleanup


# If you need to troubleshoot here are some logs
# Primary
#kubectl logs --container mongodb-replicaset mongodb-mongodb-replicaset-0
# Persisted
#kubectl logs --container mongodb-replicaset mongodb-mongodb-replicaset-2
# You can also just drop into a shell and see what's happening
#kubectl exec -it --container mongodb-replicaset mongodb-mongodb-replicaset-2 bash
#kubectl exec -it --container mongodb-replicaset mongodb-mongodb-replicaset-0 -- mongo admin -u username -p password
