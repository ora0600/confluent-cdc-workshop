output "A01_resource_group_name" {
  value = azurerm_resource_group.rg_cdc_workshop.name
}

output "A02_StorageAccount"{
    value = azurerm_storage_account.cdc_workshop_storage_account
    sensitive = true
}

output "A03_PUBLICIP" {
  value = azurerm_linux_virtual_machine.cdc_workshop_terraform_oracle.public_ip_address
}

output "A04_SSH" {
    value = "ssh -i $${TF_VAR_publicsshkey:0:(-4)} ${var.vm_user}@${azurerm_linux_virtual_machine.cdc_workshop_terraform_oracle.public_ip_address}"
}

output "A05_OracleAccess" {
  value = "sqlplus sys/confluent123@XE as sysdba or sqlplus sys/confluent123@XEPDB1 as sysdba or sqlplus ordermgmt/kafka@XEPDB1  Port:1521  HOST:${azurerm_linux_virtual_machine.cdc_workshop_terraform_oracle.public_ip_address}"
}
