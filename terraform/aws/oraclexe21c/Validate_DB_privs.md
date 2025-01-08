# Validate Database Privileges in Oracle DB for Oracle CDC Connector Setup

We will ue the script described in the documentation. See [automated readiness check](https://docs.confluent.io/kafka-connectors/oracle-cdc/current/prereqs-validation.html#automated-readiness-check)

Do the following steps for validation

```bash
# Login into oracle
ssh -i ~/keys/cmawskeycdcworkshop.pem ec2-user@PUBIP
# Go into DB container
sudo docker exec -it oracle21c /bin/bash
# Get the readiness script
curl -O https://docs.confluent.io/kafka-connectors/oracle-cdc/current/_downloads/e32ba2efc9a8c9b0976b02ac04fb46a8/oracle-readiness.sql
# Execute the script
sqlplus sys/confluent123@XE as sysdba 
SQL> @oracle-readiness.sql C##MYUSER XEPDB1
# you will see 517 or 518 if so enter /
/
# Output should be
# Running prerequistes check for Confluent Oracle CDC connector on Oracle Database 21 for the user C##MYUSER
# Detected multitenant database architecture.
# PDB supplied: XEPDB1

# Validating required system priviliges:
# SUCCESS: Connector user has the required system privileges.

# Validating required SELECT privileges to objects:
# FAILED: Connector user C##MYUSER is missing some of the required SELECT object privileges - ALL_INDEXES, ALL_OBJECTS, ALL_USERS, ALL_CATALOG, ALL_CONSTRAINTS, ALL_CONS_COLUMNS, ALL_TAB_COLS,
# ALL_IND_COLUMNS, ALL_ENCRYPTED_COLUMNS, ALL_LOG_GROUPS, ALL_TAB_PARTITIONS
# Please refer to the documentation for steps to grant this access -
# https://docs.confluent.io/cloud/current/connectors/cc-oracle-cdc-source/oracle-cdc-setup-includes/prereqs-validation.html#connect-oracle-cdc-source-prereqs-user-privileges

# Validating required EXECUTE privileges to objects:
# SUCCESS: Connector user has the required EXECUTE object privileges.

# Validating database log mode:
# SUCCESS: Database is set to ARCHIVELOG mode as expected.

# Validating supplemental logging:
# WARN: ALL column supplemental logging is enabled at the database level. Confluent recommends enabling minimal supplemental logging at the database level and ALL column supplemental logging for the
# specific tables that require change data capture.
# Please refer to the documentation for the procedure to enable supplemental logging -
# https://docs.confluent.io/cloud/current/connectors/cc-oracle-cdc-source/oracle-cdc-setup-includes/prereqs-validation.html#connect-oracle-cdc-source-prereqs-enable-supplemental-logging

# Validating flashback access:
# WARN: Connector user C##MYUSER does not have FLASHBACK ANY TABLE system privilege. This user must have either the FLASHBACK ANY TABLE system privilege or have FLASHBACK object privilege on the
# specific tables to snapshot.
# Please refer to the documentation for the steps on how to grant this access -
# https://docs.confluent.io/cloud/current/connectors/cc-oracle-cdc-source/oracle-cdc-setup-includes/prereqs-validation.html#connect-oracle-cdc-source-prereqs-grant-user-flashback

# Validating archive log retention period:
# WARN: Can not check archive log retention time for non AWS RDS environment. Confluent recommends you increase your archive log retention policies to at least 24 hours.

# Validating redo log switch frequency:
# SUCCESS: Redo log switch frequency within recommended value.

# Finished script execution.

# PL/SQL procedure successfully completed.
SQL> exit;
```

We do see the following output:

* **SUCCESS**: everything is ok
* **FAILED**: Connector user C##MYUSER is missing some of the required SELECT object privileges - `ALL_INDEXES, ALL_OBJECTS, ALL_USERS, ALL_CATALOG, ALL_CONSTRAINTS, ALL_CONS_COLUMNS, ALL_TAB_COLS, ALL_IND_COLUMNS, ALL_ENCRYPTED_COLUMNS, ALL_LOG_GROUPS, ALL_TAB_PARTITIONS` this is not a problem, because the views with ALL_ are visible for all users in the DB.
* **WARN**: ALL column supplemental logging is enabled at the database level. Confluent recommends enabling minimal supplemental logging at the database level and ALL column supplemental logging for the specific tables that require change data capture. Yes, this is a bett setup for a productive database.
* **WARN**: Connector user C##MYUSER does not have FLASHBACK ANY TABLE system privilege. This user must have either the FLASHBACK ANY TABLE system privilege or have FLASHBACK object privilege on the specific tables to snapshot. We did implement `FLASHBACK object privilege` for all our tables. FLASHBACK ANY TABLE could be a security issue. 
* **WARN**: Can not check archive log retention time for non AWS RDS environment. Confluent recommends you increase your archive log retention policies to at least 24 hours. Please check manually, that archive logs are not deleted < 24h from the disk.

back to [Oracle DB Overview](README.md) or continue with the [Oracle CDC Connector](../ccloud-source-oracle-cdc-connector/README.md)