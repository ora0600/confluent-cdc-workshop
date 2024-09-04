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
source .aws_env
terraform destroy
rm .aws_env
rm basedir

echo "Oracle CDC connector"
cd ../ccloud-source-oracle-cdc-connector/
source .ccloud_env
terraform destroy
rm .ccloud_env

echo "oracle DB Service"
cd ../oraclexe21c
source .aws_env
terraform destroy
rm .aws_env
rm basedir

echo "S3 Sink Connector"
cd ../ccloud-sink-s3-connector
source .ccloud_env
terraform destroy
rm .ccloud_env
rm rm basedir

echo "S3 AWS"
cd ../aws-s3
source .aws_env
terraform destroy
rm .aws_env

echo "Redshift Sink Connector"
cd ../ccloud-sink-redshift-connector/
source .ccloud_env
terraform destroy
rm .ccloud_env

echo "Redshift AWS"
cd ../aws-redshift/
source .aws_env
terraform destroy
rm .aws_env
rm basedir

echo "Confluent Cloud Cluster including environment"
cd ../ccloud-cluster
source ../.accounts
terraform destroy
rm basedir
echo "if you have an error now, execute terraform destroy again in aws/ccloud-cluster"

echo "Deletion should be complete. Please check again in AWS and Confluent Cloud if everything is deleted. FINISHED"