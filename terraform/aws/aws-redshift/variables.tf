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

variable "myip" {
}

variable "allowed_cidr_blocks" {
  description = "(Required) A comma separated list of CIDR blocks allowed to mount target. Add egress static IPs from Confluent Cloud"
  type        = list(string)
  default     = ["0.0.0.0/32"]
}

variable "rs_cluster_identifier" {
  type = string
  default = "cdcworkshop-cluster"
}

variable "rs_database_name" {
  type = string
  default = "cdcworkshop_rsdb"
}

variable "rs_master_username" {
  type = string
  default = "cdcworkshopuser"
}

variable "rs_master_password" {
  type = string
  default = "cdcworkshop4Confluent"
  sensitive   = true
}

variable "rs_nodetype" {
  description = "Redshift node type"
  type        = string
  default     = "dc2.large"
}

variable "rs_port" {
  description = "Redshift database port"
  type        = number
  default     = 5439
}

variable "rs_number_of_nodes" {
  description = "Redshift number of nodes"
  type        = number
  default     = 1
}

variable "rs_publicly_accessible" {
  description = "Redshift cluster can be accessed from a public network "
  type        = bool
  default     = true
}

variable "owner_email"{

}
