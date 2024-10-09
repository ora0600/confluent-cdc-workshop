###########################################
################# Outputs #################
###########################################

output "A01_resource_group_name" {
  value = azurerm_resource_group.rg_cdc_workshop.name
}

output "A02_StorageAccount"{
    value = azurerm_storage_account.cdc_workshop_storage_account
    sensitive = true
}

output "A03_PUBLICIP" {
  value = azurerm_linux_virtual_machine.cdc_workshop_terraform_mysql_postgres.public_ip_address
}

output "A04_SSH" {
    value = "ssh -i $${TF_VAR_publicsshkey:0:(-4)} ${var.vm_user}@${azurerm_linux_virtual_machine.cdc_workshop_terraform_mysql_postgres.public_ip_address}"
}

output "A05_pls_cli_access" {
  description = "pls Access from your desktop"
  value = "postgres cli: psql -h ${azurerm_linux_virtual_machine.cdc_workshop_terraform_mysql_postgres.public_ip_address} -p 5432 -U postgres-user -d customers"
}

output "A06_mysqlsh_cli_access" {
  description = "mysqlsh Access from your desktop"
  value = "mysql shell: mysqlsh mysqluser@${azurerm_linux_virtual_machine.cdc_workshop_terraform_mysql_postgres.public_ip_address}:3306/demo"
}  
