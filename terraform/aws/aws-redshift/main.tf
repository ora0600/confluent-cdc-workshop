resource "aws_redshift_cluster" "cdcworkshop" {
  cluster_identifier  = "${var.rs_cluster_identifier}-${random_id.id.hex}"
  database_name       = "${var.rs_database_name}_${random_id.id.hex}"
  master_username     = var.rs_master_username
  master_password     = var.rs_master_password
  node_type           = var.rs_nodetype
  number_of_nodes     = var.rs_number_of_nodes
  cluster_type        = "single-node"
  port                = var.rs_port
  skip_final_snapshot = true
  publicly_accessible = var.rs_publicly_accessible
  automated_snapshot_retention_period = 0 
  apply_immediately = true

  tags = {
    "Name"        = "cdcworkshop-redshift-${random_id.id.hex}",
    "owner_email" = var.owner_email
  }

}

resource "aws_vpc" "redshift_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    "Name"        = "cdcworkshop-redshift-vpc-${random_id.id.hex}",
    "owner_email" = var.owner_email
  }
}


resource "aws_default_security_group" "redshift_security_group" {
  vpc_id = aws_vpc.redshift_vpc.id
  ingress {
    from_port   = var.rs_port
    to_port     = var.rs_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }
}