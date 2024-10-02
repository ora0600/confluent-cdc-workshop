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

variable "project_zone" {
}

variable "confluentcdcsetup" {
  default = "https://github.com/ora0600/confluent-cdc-workshop/archive/refs/heads/main.zip"
}

variable "owner_email" {
}

variable "vm_user" {
}