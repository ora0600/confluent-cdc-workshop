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

variable "instance_count" {
    default = "1"
  }

variable "myip" {
  }

variable "ami_oracle21c" {
  }


variable "oracledbdemo" {
  default = "https://github.com/ora0600/confluent-ksqldb-hands-on-workshop/archive/master.zip"
}
