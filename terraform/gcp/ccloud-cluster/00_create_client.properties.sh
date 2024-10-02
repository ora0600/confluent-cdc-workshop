#!/bin/bash

## Internal variables
pwd > basedir
export BASEDIR=$(cat basedir)
echo $BASEDIR

export envid=$1 
export clusterid=$2 
export connectorsa=$3 
export bootstrap=$4 
export connectorkey=$5 
export connectorsecret=$6 
export srrestpoint=$7 
export srkey=$8 
export srsecret=$9 
#export ipaddresses=$(echo -e "$(terraform output -json ip_addresses)")
#echo $ipaddresses
# Egress IPs
#export ipegress_temp=$(echo $ipaddresses | jq -r '.[].ip_prefix' |  xargs | sed -e 's/ /","/g')
#export ipegress=$(echo $ipegress_temp | sed -e 's/"/\\"/g')
#echo $ipegress
#export myip=$(dig +short myip.opendns.com @resolver1.opendns.com)
#echo $myip

# Get credentials for gcp
source ../.accounts
# Generate .gcp_env for Oracle21c setup
#echo "export TF_VAR_myip="\"${myip}/32\""
#export TF_VAR_allowed_cidr_blocks="\"["\\\"${ipegress}\\\"",\\\""${myip}/32\\\""]\""
echo "export TF_VAR_gcp_credentials="\"${gcp_credentials}\""
export TF_VAR_project_id="\"${project_id}\""
export TF_VAR_project_region="\"${TF_VAR_cc_cloud_region}\""
export TF_VAR_project_zone="\"${project_zone}\""
export TF_VAR_service_account_name="\"${service_account_name}\""
export TF_VAR_owner_email="\"${owner_email}\""
export TF_VAR_ssh_key_name="\"${ssh_key_name}\""
export confluent_cloud_api_key="\"${TF_VAR_confluent_cloud_api_key}\""
export confluent_cloud_api_secret="\"${TF_VAR_confluent_cloud_api_secret}\""
export envid="\"${envid}\""
export clusterid="\"${clusterid}\""
export said="\"${connectorsa}\""
export bootstrap="\"${bootstrap}\""
export connectorkey="\"${connectorkey}\""
export connectorsecret="\"${connectorsecret}\""
export srrestpoint="\"${srrestpoint}\""
export srkey="\"${srkey}\""
export srsecret="\"${srsecret}\"""> ../oraclexe21c/.gcp_env

# Generate .gcp_env for mysql and postgresql compute service setup
#echo "export TF_VAR_myip="\"${myip}/32\""
#export TF_VAR_allowed_cidr_blocks="\"["\\\"${ipegress}\\\"",\\\""${myip}/32\\\""]\""
echo "export TF_VAR_gcp_credentials="\"${gcp_credentials}\""
export TF_VAR_project_id="\"${project_id}\""
export TF_VAR_project_region="\"${TF_VAR_cc_cloud_region}\""
export TF_VAR_project_zone="\"${project_zone}\""
export TF_VAR_service_account_name="\"${service_account_name}\""
export TF_VAR_owner_email="\"${owner_email}\""
export TF_VAR_ssh_key_name="\"${ssh_key_name}\""
export confluent_cloud_api_key="\"${TF_VAR_confluent_cloud_api_key}\""
export confluent_cloud_api_secret="\"${TF_VAR_confluent_cloud_api_secret}\""
export envid="\"${envid}\""
export clusterid="\"${clusterid}\""
export said="\"${connectorsa}\"""> ../mysql_postgres/.gcp_env

# Generate .gcp_env for gcp storage service setup
#echo "export TF_VAR_myip="\"${myip}/32\""
#export TF_VAR_allowed_cidr_blocks="\"["\\\"${ipegress}\\\"",\\\""${myip}/32\\\""]\""
echo "export TF_VAR_gcp_credentials="\"${gcp_credentials}\""
export TF_VAR_project_id="\"${project_id}\""
export TF_VAR_project_region="\"${TF_VAR_cc_cloud_region}\""
export TF_VAR_project_zone="\"${project_zone}\""
export TF_VAR_service_account_name="\"${service_account_name}\""
export TF_VAR_owner_email="\"${owner_email}\""
export TF_VAR_bucket_name="\"${bucket_name}\""
export confluent_cloud_api_key="\"${TF_VAR_confluent_cloud_api_key}\""
export confluent_cloud_api_secret="\"${TF_VAR_confluent_cloud_api_secret}\""
export envid="\"${envid}\""
export clusterid="\"${clusterid}\""
export said="\"${connectorsa}\"""> ../gcp-storage/.gcp_env

# Generate .gcp_env for gcp-bigquerry service setup
#echo "export TF_VAR_myip="\"${myip}/32\""
#export TF_VAR_allowed_cidr_blocks="\"["\\\"${ipegress}\\\"",\\\""${myip}/32\\\""]\""
echo "export TF_VAR_gcp_credentials="\"${gcp_credentials}\""
export TF_VAR_project_id="\"${project_id}\""
export TF_VAR_project_region="\"${TF_VAR_cc_cloud_region}\""
export TF_VAR_project_zone="\"${project_zone}\""
export TF_VAR_service_account_name="\"${service_account_name}\""
export TF_VAR_owner_email="\"${owner_email}\""
export confluent_cloud_api_key="\"${TF_VAR_confluent_cloud_api_key}\""
export confluent_cloud_api_secret="\"${TF_VAR_confluent_cloud_api_secret}\""
export envid="\"${envid}\""
export clusterid="\"${clusterid}\""
export said="\"${connectorsa}\"""> ../gcp-bigquerry/.gcp_env

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
