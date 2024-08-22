###########################################
################# Outputs #################
###########################################


output "A00_bucket_details" {
  description = "S3 bucket"
  value       = aws_s3_bucket.cdcworkshop_bucket
}

output "A02_bucket_name" {
  description = "Bucket Name"
  value       = aws_s3_bucket.cdcworkshop_bucket.id
}

