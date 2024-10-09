#!/bin/bash

## Internal variables
pwd > basedir
export BASEDIR=$(cat basedir)
echo $BASEDIR

export bucket_name=$1
#export bucket_name=$(echo -e "$(terraform output -raw A02_bucket_name)")
#echo $bucket_name

# Get credentials for GCP Storage SINK Connector
source .gcp_env

# Generate .ccloud_env for Google Storage Sink Ccloud connector setup

echo "export TF_VAR_gcp_credentials="\"${TF_VAR_gcp_credentials}\""
export TF_VAR_confluent_cloud_api_key="\"${confluent_cloud_api_key}\""
export TF_VAR_confluent_cloud_api_secret="\"${confluent_cloud_api_secret}\""
export TF_VAR_envid="\"${envid}\""
export TF_VAR_clusterid="\"${clusterid}\""
export TF_VAR_said="\"${said}\""
export TF_VAR_bucket_name="\"${bucket_name}\"""> ../ccloud-sink-storage-connector/.ccloud_env
