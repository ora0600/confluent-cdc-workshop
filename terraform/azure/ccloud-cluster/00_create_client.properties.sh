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

# Get credentials for azure
source ../.accounts
# Generate .azure_env for Oracle21c setup
echo "export TF_VAR_vm_user="\"${vm_user}\""
export TF_VAR_publicsshkey="\"${publicsshkey}\""
export TF_VAR_resource_group_location="\"${TF_VAR_cc_cloud_region}\""
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
export srsecret="\"${srsecret}\"""> ../oraclexe21c/.azure_env

# Generate .azure_env for mysql and postgresql compute service setup
echo "export TF_VAR_vm_user="\"${vm_user}\""
export TF_VAR_publicsshkey="\"${publicsshkey}\""
export TF_VAR_resource_group_location="\"${TF_VAR_cc_cloud_region}\""
export confluent_cloud_api_key="\"${TF_VAR_confluent_cloud_api_key}\""
export confluent_cloud_api_secret="\"${TF_VAR_confluent_cloud_api_secret}\""
export envid="\"${envid}\""
export clusterid="\"${clusterid}\""
export said="\"${connectorsa}\"""> ../mysql_postgres/.azure_env

# Generate .azure_env for azure storage service setup
echo "export TF_VAR_vm_user="\"${vm_user}\""
export TF_VAR_resource_group_location="\"${TF_VAR_cc_cloud_region}\""
export TF_VAR_bucket_name="\"${bucket_name}\""
export confluent_cloud_api_key="\"${TF_VAR_confluent_cloud_api_key}\""
export confluent_cloud_api_secret="\"${TF_VAR_confluent_cloud_api_secret}\""
export envid="\"${envid}\""
export clusterid="\"${clusterid}\""
export said="\"${connectorsa}\"""> ../azure-storage/.azure_env

# Generate .azure_env for synapse service setup
echo "export TF_VAR_vm_user="\"${vm_user}\""
export TF_VAR_resource_group_location="\"${TF_VAR_cc_cloud_region}\""
export confluent_cloud_api_key="\"${TF_VAR_confluent_cloud_api_key}\""
export confluent_cloud_api_secret="\"${TF_VAR_confluent_cloud_api_secret}\""
export envid="\"${envid}\""
export clusterid="\"${clusterid}\""
export said="\"${connectorsa}\"""> ../azure-synapse/.azure_env

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
