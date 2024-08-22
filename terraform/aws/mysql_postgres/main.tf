resource "aws_security_group" "cdcworkshop-mysql-sg" {
  name        = "cdcworkshop-mysql-sg"
  description = "Security Group for Confluent CDC Workshop mysql and postgres setup"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.myip]
  }
  # prostgres
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }
  # mysql
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "cdc-workshop-mysql-postgres-db" {
  ami           = "${data.aws_ami.ami.id}"
  instance_type = var.instance_type_resource
  key_name      = var.ssh_key_name
  vpc_security_group_ids = ["${aws_security_group.cdcworkshop-mysql-sg.id}"]
  user_data = data.template_file.confluent_instance.rendered

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }

  tags = {
    "Name" = "cdcworkshop-mysql-postgres-instance-${random_id.id.hex}",
    "owner_email" = var.owner_email
  }

  provisioner "local-exec" {
    command = "bash ./00_create_client.properties.sh ${aws_instance.cdc-workshop-mysql-postgres-db.public_ip}"
    when = create
  }
}
