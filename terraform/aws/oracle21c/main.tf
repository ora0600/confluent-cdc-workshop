resource "aws_security_group" "cdcworkshop_oracle21c-sg" {
  name        = "cdcworkshop_oracle21c-sg"
  description = "Security Group for cdc workshop abd oracle 21c "

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # DB
  ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = [var.myip]
  }
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#"${data.aws_ami.ami.id}"

resource "aws_instance" "cdcworkshop_oracle21c" {
  ami           = var.ami_oracle21c
  count         = var.instance_count
  instance_type = var.instance_type_resource
  key_name      = var.ssh_key_name
  vpc_security_group_ids = ["${aws_security_group.cdcworkshop_oracle21c-sg.id}"]
  user_data = data.template_file.oracle_instance.rendered

#  root_block_device {
#    volume_type = "gp2"
#    volume_size = 100
#  }

  tags = {
    "Name" = "Oracle 21c for CDC Workshop",
    "Owner" = "cmutzlitz@confluent.io"
  }
}
