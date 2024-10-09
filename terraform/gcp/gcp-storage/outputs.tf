###########################################
################# Outputs #################
###########################################


output "A00_bucket_details" {
  description = "Google Storage bucket"
  value       = google_storage_bucket.cdcworkshop_bucket
}

output "A02_bucket_name" {
  description = "Bucket Name"
  value       = google_storage_bucket.cdcworkshop_bucket.id
}

