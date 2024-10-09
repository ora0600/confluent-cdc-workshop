###########################################
################# Outputs #################
###########################################

output "A00_vpc_network" {
  description = "The URI of the created VPC network."
  value       = google_compute_network.vpc_network.self_link
}

output "A01_vpc_network_name" {
  description = "The name of the vpc."
  value       = google_compute_network.vpc_network.name
}

output "A02_instance_details" {
  description = "The name of the compute instance."
  value       = google_compute_instance.cdcworkshop_mysqlpostgres
  sensitive = true
}

output "A03_PUBLICIP" {
  value = "${google_compute_instance.cdcworkshop_mysqlpostgres.network_interface.0.access_config.0.nat_ip}"
}

output "A04_SSH" {
  description = "SSH Access"
  value       = "Please use SSH connection in Compute Engine Console"
}

output "A05_pls_cli_access" {
  description = "pls Access from your desktop"
  value = "postgres cli: psql -h ${google_compute_instance.cdcworkshop_mysqlpostgres.network_interface.0.access_config.0.nat_ip} -p 5432 -U postgres-user -d customers"
}  

output "A06_mysqlsh_cli_access" {
  description = "mysqlsh Access from your desktop"
  value = "mysql shell: mysqlsh mysqluser@${google_compute_instance.cdcworkshop_mysqlpostgres.network_interface.0.access_config.0.nat_ip}:3306/demo"
}  
