###########################################
################# Outputs #################
###########################################

output "PublicIPs" {
  value = tonumber(var.instance_count) >= 1 ? " Public IP Adresses are ${join(",",formatlist("%s", aws_instance.cdcworkshop_oracle21c.*.public_ip),)} " : "AWS is disabled" 
}

output "SSH" {
  value = tonumber(var.instance_count) >= 1 ? " SSH  Access: ssh -i ~/keys/cmawskeycdcworkshop.pem ec2-user@${join(",",formatlist("%s", aws_instance.cdcworkshop_oracle21c.*.public_ip),)} " : "AWS is disabled" 
}

output "OracleAccess" {
  value = tonumber(var.instance_count) >= 1 ? " sys/confluent123@ORCLCDB as sysdba or sys/confluent123@ORCLPDB1 as sysdba or ordermgmt/kafka@ORCLPDB1  Port:1521  HOST:${join(",",formatlist("%s", aws_instance.cdcworkshop_oracle21c.*.public_ip),)} " : "AWS is disabled" 
}
