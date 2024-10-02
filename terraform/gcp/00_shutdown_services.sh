#!/bin/bash

echo "Shutdown all services of the CDC Workshop"

echo "Salesforce Connector"
cd ccloud-source-salesforce-cdc-connector/
source .ccloud_env
terraform destroy
rm .ccloud_env

echo "mysql CDC Connector"
cd ../ccloud-source-mysql-cdc-connector/
source .ccloud_env
terraform destroy
rm .ccloud_env

echo "posgreSQL CDC Connector"
cd ../ccloud-source-postgresql-cdc-connector/
source .ccloud_env
terraform destroy
rm .ccloud_env

echo "mysql/postgresql DB services"
cd ../mysql_postgres/
source .gcp_env
terraform destroy
rm .gcp_env
rm basedir

echo "Oracle CDC connector"
cd ../ccloud-source-oracle-cdc-connector
source .ccloud_env
terraform destroy
rm .ccloud_env
rm migrateConnectors/.env
rm migrateConnectors/cdc_ccloud.json

echo "oracle DB Service"
cd ../oraclexe21c
source .gcp_env
terraform destroy
rm .gcp_env
rm basedir

echo "Storage Sink Connector"
cd ../ ccloud-sink-storage-connector
source .ccloud_env
terraform destroy
rm .ccloud_env
rm rm basedir

echo "Google Clous Storage"
cd ../gcp-storage
source .gcp_env
terraform destroy
rm .gcp_env

echo "Bigquery Sink Connector"
cd ../ccloud-sink-bigquery-connector/
source .ccloud_env
terraform destroy
rm .ccloud_env

echo "Google Bigquery"
cd ../gcp-bigquerry/
source .gcp_env
terraform destroy
rm .gcp_env
rm basedir

echo "Confluent Cloud Cluster including environment"
cd ../ccloud-cluster
source ../.accounts
terraform destroy
rm basedir

echo "********************************************************************************"
echo "if you have an error now, execute terraform destroy again in gcp/ccloud-cluster"
echo "********************************************************************************"
echo
echo "Deletion should be complete. Please check again in AWS and Confluent Cloud if everything is deleted. FINISHED"