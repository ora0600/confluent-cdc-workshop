resource "random_id" "id" {
  byte_length = 2
}
# AWS Config
variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "aws_region" {
}

variable "ssh_key_name" {
}

variable "instance_type_resource" {
  default = "t2.xlarge"
}

variable "myip" {
}

variable "confluentcdcsetup" {
  default = "https://github.com/ora0600/confluent-cdc-workshop/archive/refs/heads/main.zip"
}

variable "allowed_cidr_blocks" {
  description = "(Required) A comma separated list of CIDR blocks allowed to mount target. Add egress static IPs from Confluent Cloud"
  type        = list(string)
  default     = ["0.0.0.0/32"]
}

variable "owner_email" {
}
