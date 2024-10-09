#!/bin/bash

echo "Shutdown all services of the CDC Workshop"

echo "Salesforce Connector"
cd ccloud-source-salesforce-cdc-connector/
if [ -e "terraform.tfstate" ]; then
    source .ccloud_env
    terraform destroy
    rm .ccloud_env
else 
    echo "Salesforce Connector was not deployed"
fi 


echo "mysql CDC Connector"
cd ../ccloud-source-mysql-cdc-connector/
if [ -e "terraform.tfstate" ]; then
    source .ccloud_env
    terraform destroy
    rm .ccloud_env
else 
    echo "mySQL Connector was not deployed"
fi 

echo "postgreSQL CDC Connector"
cd ../ccloud-source-postgresql-cdc-connector/
if [ -e "terraform.tfstate" ]; then
    source .ccloud_env
    terraform destroy
    rm .ccloud_env
else 
    echo "Postgres Connector was not deployed"
fi 

echo "mysql/postgresql DB services"
cd ../mysql_postgres/
if [ -e "terraform.tfstate" ]; then
    source .gcp_env
    terraform destroy
    rm .gcp_env
    rm basedir
else 
    echo "mysql/Postgres DB compute service was not deployed"
fi 


echo "Oracle CDC connector"
cd ../ccloud-source-oracle-cdc-connector
if [ -e "terraform.tfstate" ]; then
    source .ccloud_env
    terraform destroy
    rm .ccloud_env
    rm migrateConnectors/.env
    rm migrateConnectors/cdc_ccloud.json
else 
    echo "Oracle CDC Connector was not deployed"
fi 

echo "oracle DB Service"
cd ../oraclexe21c
if [ -e "terraform.tfstate" ]; then
    source .gcp_env
    terraform destroy
    rm .gcp_env
    rm basedir
else 
    echo "Oracle DB compute service was not deployed"
fi 


echo "Storage Sink Connector"
cd ../ccloud-sink-storage-connector
if [ -e "terraform.tfstate" ]; then
    source .ccloud_env
    terraform destroy
    rm .ccloud_env
    rm basedir
else 
    echo "Storage Sink Connector was not deployed"
fi 

echo "Google Cloud Storage"
cd ../gcp-storage
if [ -e "terraform.tfstate" ]; then
    source .gcp_env
    terraform destroy
    rm .gcp_env
else 
    echo "Cloud Storage Bucket was not deployed"
fi 

echo "Bigquery Sink Connector"
cd ../ccloud-sink-bigquery-connector/
if [ -e "terraform.tfstate" ]; then
    source .ccloud_env
    terraform destroy
    rm .ccloud_env
else 
    echo "Bigquery Sink Connector was not deployed"
fi 

echo "Google Bigquery"
cd ../gcp-bigquerry/
if [ -e "terraform.tfstate" ]; then
    source .gcp_env
    terraform destroy
    rm .gcp_env
    rm basedir
else 
    echo "Bigquery Cloud Service was not deployed"
fi 

echo "Confluent Cloud Cluster including environment"
cd ../ccloud-cluster
if [ -e "terraform.tfstate" ]; then
    source ../.accounts
    terraform destroy
    rm basedir
else 
    echo "Confluent Cloud Cluster was not deployed"
fi 

echo "********************************************************************************"
echo "if you have an error now, execute terraform destroy again in gcp/ccloud-cluster"
echo "********************************************************************************"
echo
echo "Deletion should be complete. Please check again in GCP and Confluent Cloud if everything is deleted. FINISHED"