# --------------------------------------------------------
# Flink Compute Pool
# --------------------------------------------------------
resource "confluent_flink_compute_pool" "cc_flink_compute_pool" {
  display_name = "${var.cc_compute_pool_name}-${random_id.id.hex}"
  cloud        = var.cc_cloud_provider
  region       = var.cc_cloud_region
  max_cfu      = var.cc_compute_pool_cfu
  environment {
    id = confluent_environment.cc_handson_env.id
  }
  depends_on = [
    confluent_kafka_cluster.cc_kafka_cluster
  ]
  lifecycle {
    prevent_destroy = false
  }
}

