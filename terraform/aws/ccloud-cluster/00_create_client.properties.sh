#!/bin/bash

## Internal variables
pwd > basedir
export BASEDIR=$(cat basedir)
echo $BASEDIR

export envid=$1 
export clusterid=$2 
export connectorsa=$3 
export ipaddresses=$(echo -e "$(terraform output -json ip_addresses)")
#echo $ipaddresses
# Egress IPs
export ipegress_temp=$(echo $ipaddresses | jq -r '.[].ip_prefix' |  xargs | sed -e 's/ /","/g')
export ipegress=$(echo $ipegress_temp | sed -e 's/"/\\"/g')
#echo $ipegress
export myip=$(dig +short myip.opendns.com @resolver1.opendns.com)
#echo $myip

# Get credentials for aws
source ../.accounts
# Generate .aws_env for Oracle21c setup
echo "export TF_VAR_myip="\"${myip}/32\""
export TF_VAR_allowed_cidr_blocks="\"["\\\"${ipegress}\\\"",\\\""${myip}/32\\\""]\""
export TF_VAR_aws_access_key="\"${aws_access_key}\""
export TF_VAR_aws_secret_key="\"${aws_secret_key}\""
export TF_VAR_aws_region="\"${aws_region}\""
export TF_VAR_ssh_key_name="\"${ssh_key_name}\""
export TF_VAR_ami_oracle21c="\"${ami_oracle21c}\""
export TF_VAR_owner_email="\"${owner_email}\""
export confluent_cloud_api_key="\"${TF_VAR_confluent_cloud_api_key}\""
export confluent_cloud_api_secret="\"${TF_VAR_confluent_cloud_api_secret}\""
export envid="\"${envid}\""
export clusterid="\"${clusterid}\""
export said="\"${connectorsa}\"""> ../oraclexe21c/.aws_env

# Generate .aws_env for mysql and postgresql compute service setup
echo "export TF_VAR_myip="\"${myip}/32\""
export TF_VAR_allowed_cidr_blocks="\"["\\\"${ipegress}\\\"",\\\""${myip}/32\\\""]\""
export TF_VAR_aws_access_key="\"${aws_access_key}\""
export TF_VAR_aws_secret_key="\"${aws_secret_key}\""
export TF_VAR_aws_region="\"${aws_region}\""
export TF_VAR_ssh_key_name="\"${ssh_key_name}\""
export TF_VAR_owner_email="\"${owner_email}\""
export confluent_cloud_api_key="\"${TF_VAR_confluent_cloud_api_key}\""
export confluent_cloud_api_secret="\"${TF_VAR_confluent_cloud_api_secret}\""
export envid="\"${envid}\""
export clusterid="\"${clusterid}\""
export said="\"${connectorsa}\"""> ../mysql_postgres/.aws_env

# Generate .aws_env for s3 service setup
echo "export TF_VAR_myip="\"${myip}/32\""
export TF_VAR_allowed_cidr_blocks="\"["\\\"${ipegress}\\\"",\\\""${myip}/32\\\""]\""
export TF_VAR_aws_access_key="\"${aws_access_key}\""
export TF_VAR_aws_secret_key="\"${aws_secret_key}\""
export TF_VAR_aws_region="\"${aws_region}\""
export TF_VAR_owner_email="\"${owner_email}\""
export TF_VAR_bucket_name="\"${bucket_name}\""
export confluent_cloud_api_key="\"${TF_VAR_confluent_cloud_api_key}\""
export confluent_cloud_api_secret="\"${TF_VAR_confluent_cloud_api_secret}\""
export envid="\"${envid}\""
export clusterid="\"${clusterid}\""
export said="\"${connectorsa}\"""> ../aws-s3/.aws_env

# Generate .aws_env for aws-redshift service setup
echo "export TF_VAR_myip="\"${myip}/32\""
export TF_VAR_allowed_cidr_blocks="\"["\\\"${ipegress}\\\"",\\\""${myip}/32\\\""]\""
export TF_VAR_aws_access_key="\"${aws_access_key}\""
export TF_VAR_aws_secret_key="\"${aws_secret_key}\""
export TF_VAR_aws_region="\"${aws_region}\""
export TF_VAR_owner_email="\"${owner_email}\""
export confluent_cloud_api_key="\"${TF_VAR_confluent_cloud_api_key}\""
export confluent_cloud_api_secret="\"${TF_VAR_confluent_cloud_api_secret}\""
export envid="\"${envid}\""
export clusterid="\"${clusterid}\""
export said="\"${connectorsa}\"""> ../aws-redshift/.aws_env

# Generate .ccloud_env salesforce connector setup
echo "export TF_VAR_confluent_cloud_api_key="\"${TF_VAR_confluent_cloud_api_key}\""
export TF_VAR_confluent_cloud_api_secret="\"${TF_VAR_confluent_cloud_api_secret}\""
export TF_VAR_envid="\"${envid}\""
export TF_VAR_clusterid="\"${clusterid}\""
export TF_VAR_said="\"${connectorsa}\""
export TF_VAR_sf_user="\"${sf_user}\""
export TF_VAR_sf_password="\"${sf_password}\""
export TF_VAR_sf_password_token="\"${sf_password_token}\""
export TF_VAR_sf_consumer_key="\"${sf_consumer_key}\""
export TF_VAR_sf_consumer_secret="\"${sf_consumer_secret}\""
export TF_VAR_sf_cdc_name="\"${sf_cdc_name}\"""> ../ccloud-source-salesforce-cdc-connector/.ccloud_env