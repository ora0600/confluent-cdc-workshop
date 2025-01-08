 #!/bin/bash
# First enable Logging
export ORACLE_SID=AI
echo "enable logging"
sqlplus /nolog @/opt/oracle/scripts/setup/01_setup_database.sql
echo "logging enabled"
# Install user, and data
sqlplus sys/confluent123@AIPDB1 as sysdba @/opt/oracle/scripts/setup/02_create_user.sql
sqlplus ordermgmt/kafka@AIPDB1 @/opt/oracle/scripts/setup/03_create_schema_datamodel.sql
sqlplus ordermgmt/kafka@AIPDB1 @/opt/oracle/scripts/setup/04_load_data.sql
# Create CDC User and align all roles
sqlplus sys/confluent123@AIPDB1 as sysdba @/opt/oracle/scripts/setup/05_23ai_privs.sql