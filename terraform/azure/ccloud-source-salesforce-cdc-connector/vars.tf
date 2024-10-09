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

variable "sf_user" {
  description = "sf_user"
  type        = string
}

variable "sf_password" {
  description = "sf_password"
  type        = string
}

variable "sf_password_token" {
  description = "sf_password_token"
  type        = string
}

variable "sf_consumer_key" {
  description = "sf_consumer_key"
  type        = string
}

variable "sf_consumer_secret" {
  description = "sf_consumer_secret"
  type        = string
}

variable "sf_cdc_name" {
  description = "sf_cdc_name"
  type        = string
}
