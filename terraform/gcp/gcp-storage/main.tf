# main.tf
# Create new storage bucket in the US
# location with Standard Storage
resource "google_storage_bucket" "cdcworkshop_bucket" {
 name          = "${var.bucket_name}-${random_id.id.hex}"
 location      = var.project_region
 storage_class = "STANDARD"
 force_destroy = true

 uniform_bucket_level_access = true
 provisioner "local-exec" {
    command = "bash ./00_create_client.properties.sh ${google_storage_bucket.cdcworkshop_bucket.id}"
    when = create
  }
}
