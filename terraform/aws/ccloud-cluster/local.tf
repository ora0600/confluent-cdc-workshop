resource "null_resource" "create_env_files" {
  depends_on = [
    resource.confluent_environment.cc_handson_env,
    resource.confluent_schema_registry_cluster.advanced,
    resource.confluent_kafka_cluster.cc_kafka_cluster,
    resource.confluent_service_account.app_manager,
    resource.confluent_service_account.sr,
    resource.confluent_service_account.clients,
    resource.confluent_service_account.connectors,
    resource.confluent_api_key.app_manager_kafka_cluster_key,
    resource.confluent_api_key.sr_cluster_key,
    resource.confluent_api_key.clients_kafka_cluster_key,
    resource.confluent_api_key.env-manager-flink-api-key,
    resource.confluent_api_key.connector_key,
  ]
  provisioner "local-exec" {
    command = "bash ./00_create_client.properties.sh ${confluent_environment.cc_handson_env.id} ${confluent_kafka_cluster.cc_kafka_cluster.id} ${confluent_service_account.connectors.id}"
    #command = "bash ./00_create_client.properties.sh $P1 $P2 $P3 $P4 $P5 $P6 $P7 $P8 $P9 $Q1 $Q2 $Q3 $Q4 $Q5 $Q6 $Q7"
    #environment = {
      #P1 = "${confluent_environment.cc_handson_env.id}"                   # A01_cc_cdc_env 
      #P2 = "${confluent_schema_registry_cluster.advanced.id}"             # A03_cc_sr_cluster 
      #P3 = "${confluent_schema_registry_cluster.advanced.rest_endpoint}"  # A04_cc_sr_cluster_endpoint 
      #P4 = "${confluent_api_key.sr_cluster_key.id}"                       # D_01_SRKey 
      #P5 = "${confluent_api_key.sr_cluster_key.secret}"                   # D_02_SRSecret 
      #P6 = "${confluent_kafka_cluster.cc_kafka_cluster.id}"               # A05_cc_kafka_cluster 
      #P7 = "${confluent_kafka_cluster.cc_kafka_cluster.bootstrap_endpoint}" # A06_cc_kafka_cluster_bootsrap
      #P8 = "${confluent_api_key.app_manager_kafka_cluster_key.id}"        # D_03_AppManagerKey 
      #P9 = "${confluent_api_key.app_manager_kafka_cluster_key.secret}"    # D_04_AppManagerSecret 
      #Q1 = "${confluent_api_key.clients_kafka_cluster_key.id}"            # D_05_ClientKey  
      #Q2 = "${confluent_api_key.clients_kafka_cluster_key.secret}"        # D_06_ClientSecret 
      #Q3 = "${confluent_api_key.env-manager-flink-api-key.id}"            # D_07_FlinkKey 
      #Q4 = "${confluent_api_key.env-manager-flink-api-key.secret}"        # D_08_FlinkSecret 
      #Q5 = "${confluent_service_account.connectors.id}"                   # D_09_ConnectorSA 
      #Q6 = "${confluent_api_key.connector_key.id}"                        # D_10_ConnectorSAKey 
      #Q7 = "${confluent_api_key.connector_key.secret}"                    # D_11_ConnectorSASecret 
    #}
  }
}