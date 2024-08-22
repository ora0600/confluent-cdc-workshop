# main.tf

resource "aws_s3_bucket" "cdcworkshop_bucket" {
  bucket  = "cmcdc-workshop-${random_id.id.hex}"
  force_destroy = true

  tags    = {
	  Name           = "${var.bucket_name}-${random_id.id.hex}"
	  Environment    = "CDC-Workshop"
    owner_email    = "${var.owner_email}"
  }
  provisioner "local-exec" {
    command = "bash ./00_create_client.properties.sh ${aws_s3_bucket.cdcworkshop_bucket.id}"
    when = create
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.cdcworkshop_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
