#!/bin/bash

## Internal variables
pwd > basedir
export BASEDIR=$(cat basedir)
echo $BASEDIR

export pubip=$1
export oracle_host=$1

#export pubip=$(echo -e "$(terraform output -raw A01_PUBLICIP)")
#echo $pubip
#export oracle_host=$(echo -e "$(terraform output -raw A02_ORACLESERVERNAME)")
#echo $oracle_host

# Get credentials for Oracle CDC Connector
source .gcp_env

# Generate .ccloud_env for Oracle21c CDC Ccloud connector setup
echo "export TF_VAR_confluent_cloud_api_key="\"${confluent_cloud_api_key}\""
export TF_VAR_confluent_cloud_api_secret="\"${confluent_cloud_api_secret}\""
export TF_VAR_envid="\"${envid}\""
export TF_VAR_clusterid="\"${clusterid}\""
export TF_VAR_said="\"${said}\""
export TF_VAR_oracle_host="\"${oracle_host}\"""> ../ccloud-source-oracle-cdc-connector/.ccloud_env


# Generate .ccloud_env for Oracle21c CDC Ccloud connector setup
echo "export TF_VAR_confluent_cloud_api_key="\"${confluent_cloud_api_key}\""
export TF_VAR_confluent_cloud_api_secret="\"${confluent_cloud_api_secret}\""
export TF_VAR_envid="\"${envid}\""
export TF_VAR_clusterid="\"${clusterid}\""
export TF_VAR_said="\"${said}\""
export TF_VAR_oracle_host="\"${oracle_host}\""
export bootstrap="\"${bootstrap}\""
export connectorkey="\"${connectorkey}\""
export connectorsecret="\"${connectorsecret}\""
export srrestpoint="\"${srrestpoint}\""
export srkey="\"${srkey}\""
export srsecret="\"${srsecret}\"""> ../ccloud-source-oracle-cdc-connector/migrateConnectors/.env