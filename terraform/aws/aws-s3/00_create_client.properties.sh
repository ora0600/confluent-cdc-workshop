#!/bin/bash

## Internal variables
pwd > basedir
export BASEDIR=$(cat basedir)
echo $BASEDIR

export bucket_name=$1
#export bucket_name=$(echo -e "$(terraform output -raw A02_bucket_name)")
#echo $bucket_name

# Get credentials for Oracle CDC Connector
source .aws_env

# Generate .ccloud_env for Oracle21c CDC Ccloud connector setup
echo "export TF_VAR_aws_access_key="\"${TF_VAR_aws_access_key}\""
export TF_VAR_aws_secret_key="\"${TF_VAR_aws_secret_key}\""
export TF_VAR_aws_region="\"${TF_VAR_aws_region}\""
export TF_VAR_confluent_cloud_api_key="\"${confluent_cloud_api_key}\""
export TF_VAR_confluent_cloud_api_secret="\"${confluent_cloud_api_secret}\""
export TF_VAR_envid="\"${envid}\""
export TF_VAR_clusterid="\"${clusterid}\""
export TF_VAR_said="\"${said}\""
export TF_VAR_bucket_name="\"${bucket_name}\"""> ../ccloud-sink-s3-connector/.ccloud_env

