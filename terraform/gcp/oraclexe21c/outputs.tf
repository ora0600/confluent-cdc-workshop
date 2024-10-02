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
  value       = google_compute_instance.cdcworkshop_oracle21c
  sensitive = true
}

output "A03_PUBLICIP" {
  value = "${join(" ", google_compute_instance.cdcworkshop_oracle21c.*.network_interface.0.access_config.0.nat_ip)}"
}

output "A04_SSH" {
  description = "SSH Access"
  value       = "Please use SSH connection in Compute Engine Console"
}

output "A05_OracleAccess" {
  value = "sqlplus sys/confluent123@XE as sysdba or sqlplus sys/confluent123@XEPDB1 as sysdba or sqlplus ordermgmt/kafka@XEPDB1  Port:1521  HOST:${google_compute_instance.cdcworkshop_oracle21c.network_interface.0.access_config.0.nat_ip}"
}

