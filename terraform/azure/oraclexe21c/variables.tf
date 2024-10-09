variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg-cdc-workshop"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "vm_user" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
}

variable "publicsshkey" {
  type        = string
  description = "the path of the public ssh key"
}

variable "confluentcdcsetup" {
  default = "https://github.com/ora0600/confluent-cdc-workshop/archive/refs/heads/main.zip"
}