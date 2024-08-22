
# --------------------------------------------------------
# Flink SQL: CREATE TABLE salesforce_myleads
# --------------------------------------------------------
resource "confluent_flink_statement" "create_salesforce_myleads" {
  organization {
    id = data.confluent_organization.main.id
  }   
  environment {
    id = confluent_environment.cc_handson_env.id
  }
  compute_pool {
    id = confluent_flink_compute_pool.cc_flink_compute_pool.id
  }
  principal {
    id = confluent_service_account.app_manager.id
  }
  statement  = "CREATE TABLE salesforce_myleads(saluation STRING,firstname STRING,lastname STRING,email STRING);"
  properties = {
    "sql.current-catalog"  = confluent_environment.cc_handson_env.display_name
    "sql.current-database" = confluent_kafka_cluster.cc_kafka_cluster.display_name
  }
  rest_endpoint   =  data.confluent_flink_region.main.rest_endpoint
  credentials {
    key    = confluent_api_key.env-manager-flink-api-key.id
    secret = confluent_api_key.env-manager-flink-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
  depends_on = [
    resource.confluent_environment.cc_handson_env,
    resource.confluent_schema_registry_cluster.advanced,
    resource.confluent_kafka_cluster.cc_kafka_cluster,
    resource.confluent_flink_compute_pool.cc_flink_compute_pool,
    resource.confluent_kafka_topic.salesforce_contacts,
  ]   
}