###########################################
################# Outputs #################
###########################################

output "A00_instance_details" {
  description = "mysql/postgresql compute detaisl"
  value       = aws_instance.cdc-workshop-mysql-postgres-db
}

output "A01_PUBLICIP" {
  description = "mysql/postgresql Public IP"
  value       = aws_instance.cdc-workshop-mysql-postgres-db.public_ip
}  

output "A02_HOSTNAME" {
  description = "DB Servername"
  value       = aws_instance.cdc-workshop-mysql-postgres-db.public_ip
}

output "A03_SSH" {
  description = "SSH Access"
  value = "SSH  Access: ssh -i ~/keys/cmawskeycdcworkshop.pem ec2-user@${join(",",formatlist("%s", aws_instance.cdc-workshop-mysql-postgres-db.public_ip),)} " 
}

output "A03_pls_cli_access" {
  description = "pls Access from your desktop"
  value = "postgres cli: psql -h ${join(",",formatlist("%s", aws_instance.cdc-workshop-mysql-postgres-db.public_ip),)} -p 5432 -U postgres-user -d customers"
}  

output "A04_mysqlsh_cli_access" {
  description = "mysqlsh Access from your desktop"
  value = "mysql shell: mysqlsh mysqluser@${join(",",formatlist("%s", aws_instance.cdc-workshop-mysql-postgres-db.public_ip),)}:3306/demo"
}  
