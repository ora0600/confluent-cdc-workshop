#!/bin/bash

## Internal variables
pwd > basedir
export BASEDIR=$(cat basedir)
echo $BASEDIR

export pubip=$1
export host_name=$1
#export pubip=$(echo -e "$(terraform output -raw A01_PUBLICIP)")
#echo $pubip
#export host_name=$(echo -e "$(terraform output -raw A01_PUBLICIP)")
#echo $host_name

# Get credentials for mysql and postgresql CDC Connector
source .gcp_env

# Generate .ccloud_env for mysql and postgresql CDC Ccloud connector setup
echo "export TF_VAR_confluent_cloud_api_key="\"${confluent_cloud_api_key}\""
export TF_VAR_confluent_cloud_api_secret="\"${confluent_cloud_api_secret}\""
export TF_VAR_envid="\"${envid}\""
export TF_VAR_clusterid="\"${clusterid}\""
export TF_VAR_said="\"${said}\""
export TF_VAR_host_name="\"${host_name}\"""> ../ccloud-source-mysql-cdc-connector/.ccloud_env

echo "export TF_VAR_confluent_cloud_api_key="\"${confluent_cloud_api_key}\""
export TF_VAR_confluent_cloud_api_secret="\"${confluent_cloud_api_secret}\""
export TF_VAR_envid="\"${envid}\""
export TF_VAR_clusterid="\"${clusterid}\""
export TF_VAR_said="\"${said}\""
export TF_VAR_host_name="\"${host_name}\"""> ../ccloud-source-postgresql-cdc-connector/.ccloud_env
