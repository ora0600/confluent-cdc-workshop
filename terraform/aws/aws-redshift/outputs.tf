###########################################
################# Outputs #################
###########################################


output "redshift_cluster_details" {
  description = "Redshift DB details"
  value       = aws_redshift_cluster.cdcworkshop
  sensitive = true
}

output "redshift_cluster_dns" {
  description = "The DNS name of the cluster of the redshift cluster"
  value       = aws_redshift_cluster.cdcworkshop.dns_name
}