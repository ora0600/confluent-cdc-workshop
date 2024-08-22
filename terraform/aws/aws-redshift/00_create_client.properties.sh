#!/bin/bash

## Internal variables
pwd > basedir
export BASEDIR=$(cat basedir)
echo $BASEDIR

export rsdomain=$1
export rsport=$2
export rsuser=$3
export rspassword=$4
export rsdbname=$5

# Get credentials for Oracle CDC Connector
source .aws_env

# Generate .ccloud_env for Oracle21c CDC Ccloud connector setup
echo "export TF_VAR_aws_access_key="\"${TF_VAR_aws_access_key}\""
export TF_VAR_aws_secret_key="\"${TF_VAR_aws_access_key}\""
export TF_VAR_aws_region="\"${TF_VAR_aws_region}\""
export TF_VAR_confluent_cloud_api_key="\"${confluent_cloud_api_key}\""
export TF_VAR_confluent_cloud_api_secret="\"${confluent_cloud_api_secret}\""
export TF_VAR_envid="\"${envid}\""
export TF_VAR_clusterid="\"${clusterid}\""
export TF_VAR_said="\"${said}\""
export TF_VAR_rsdomain="\"${rsdomain}\""
export TF_VAR_rsport="\"${rsport}\""
export TF_VAR_rsuser="\"${rsuser}\""
export TF_VAR_rspassword="\"${rspassword}\""
export TF_VAR_rsdbname="\"${rsdbname}\"""> ../ccloud-sink-redshift-connector//.ccloud_env

