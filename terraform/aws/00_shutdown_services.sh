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
    source .aws_env
    terraform destroy
    rm .aws_env
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
    source .aws_env
    terraform destroy
    rm .aws_env
    rm basedir
else 
    echo "Oracle DB compute service was not deployed"
fi 


echo "S3 Sink Connector"
cd ../ccloud-sink-s3-connector
if [ -e "terraform.tfstate" ]; then
    source .ccloud_env
    terraform destroy
    rm .ccloud_env
    rm basedir
else 
    echo "S3 Sink Connector was not deployed"
fi 

echo "S3 AWS"
cd ../aws-s3
if [ -e "terraform.tfstate" ]; then
    source .aws_env
    terraform destroy
    rm .aws_env
else 
    echo "S3 AWS Bucket was not deployed"
fi 

echo "Redshift Sink Connector"
cd ../ccloud-sink-redshift-connector/
if [ -e "terraform.tfstate" ]; then
    source .ccloud_env
    terraform destroy
    rm .ccloud_env
else 
    echo "Redshift Sink Connector was not deployed"
fi 

echo "Redshift AWS"
cd ../aws-redshift/
if [ -e "terraform.tfstate" ]; then
    source .aws_env
    terraform destroy
    rm .aws_env
    rm basedir
else 
    echo "Redshift Service was not deployed"
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
echo "if you have an error now, execute terraform destroy again in aws/ccloud-cluster"
echo "********************************************************************************"
echo
echo "Deletion should be complete. Please check again in AWS and Confluent Cloud if everything is deleted. FINISHED"