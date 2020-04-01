# MAKE IT WORK

The last test in the `test_mongodb_restart.sh` has the steps.

It is functionally:

1. Install helm release - the `replicaset-0` is the wiredTiger
2. Run a kubectl exec to the primary (which is replicaset-0) and run `rs.stepDown()`
3. Add in some data
4. Run count
5. helm delete
6. Check which replicaset is the master if its the wiredTiger run `rs.stepDown()`. 
7. Run count
