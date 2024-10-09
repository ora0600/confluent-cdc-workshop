resource "random_id" "id" {
  byte_length = 2
}
# GCP Config
variable "gcp_credentials" {
}

variable "project_id" {
}

variable "project_region" {
}

variable "bucket_name"{
}