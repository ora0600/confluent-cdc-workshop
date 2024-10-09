# ----------------------------------------
# Confluent Cloud Kafka cluster variables
# ----------------------------------------
variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "envid" {
  description = "Confluent Cloud Environment ID"
  type        = string
}

variable "clusterid" {
  description = "Confluent Cloud cluster ID"
  type        = string
}

variable "said" {
  description = "Confluent Cloud Service Account for Connector"
  type        = string
}

variable "oracle_host" {
  description = "Oralce Host Domain Name"
  type        = string
}
