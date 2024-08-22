output "A01_cc_cdc_env" {
  description = "Confluent Cloud Environment ID"
  value       = resource.confluent_environment.cc_handson_env.id
}

output "A02_cc_cdc_sr" {
  description = "CC Schema Registry Region"
  value       = data.confluent_schema_registry_region.advanced
}

output "A03_cc_sr_cluster" {
  description = "CC SR Cluster ID"
  value       = resource.confluent_schema_registry_cluster.advanced.id
}

output "A04_cc_sr_cluster_endpoint" {
  description = "CC SR Cluster ID"
  value       = resource.confluent_schema_registry_cluster.advanced.rest_endpoint
}

output "D_01_SRKey" {
  description = "CC SR Key"
  value       = resource.confluent_api_key.sr_cluster_key.id
}

output "D_02_SRSecret" {
  description = "CC SR Secret"
  value       = resource.confluent_api_key.sr_cluster_key.secret
  sensitive = true
}

output "A05_cc_kafka_cluster" {
  description = "CC Kafka Cluster ID"
  value       = resource.confluent_kafka_cluster.cc_kafka_cluster.id
}

output "A06_cc_kafka_cluster_bootsrap" {
  description = "CC Kafka Cluster ID"
  value       = resource.confluent_kafka_cluster.cc_kafka_cluster.bootstrap_endpoint
}

output "B01_cc_compute_pool_name" {
  value = resource.confluent_flink_compute_pool.cc_flink_compute_pool.id
}

output "D_03_AppManagerKey" {
  description = "CC AppManager Key"
  value       = resource.confluent_api_key.app_manager_kafka_cluster_key.id
}

output "D_04_AppManagerSecret" {
  description = "CC AppManager Secret"
  value       = resource.confluent_api_key.app_manager_kafka_cluster_key.secret
  sensitive = true
}
        
output "D_05_ClientKey" {
  description = "CC clients Key"
  value       = resource.confluent_api_key.clients_kafka_cluster_key.id
}
output "D_06_ClientSecret" {
  description = "CC Client Secret"
  value       = resource.confluent_api_key.clients_kafka_cluster_key.secret
  sensitive = true
}

output "D_07_FlinkKey" {
  description = "CC Flink Key"
  value       = resource.confluent_api_key.env-manager-flink-api-key.id
}
output "D_08_FlinkSecret" {
  description = "CC Flink Secret"
  value       = resource.confluent_api_key.env-manager-flink-api-key.secret
  sensitive = true
}

output "D_09_ConnectorSA" {
  description = "CC ConnectorSA ID"
  value       = resource.confluent_service_account.connectors.id
}

output "D_10_ConnectorSAKey" {
  description = "CC ConnectorSA Key"
  value       = resource.confluent_api_key.connector_key.id
}

output "D_11_ConnectorSASecret" {
  description = "CC ConnectorSA Secret"
  value       = resource.confluent_api_key.connector_key.secret
  sensitive = true
}

data "confluent_ip_addresses" "main" {
  filter {
    clouds        = [var.cc_cloud_provider]
    regions       = [var.cc_cloud_region]
    services      = ["KAFKA"]
    address_types = ["EGRESS"]
  }
}

output "ip_addresses" {
  value = data.confluent_ip_addresses.main.ip_addresses
}

