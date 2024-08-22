resource "null_resource" "create_env_files" {
  depends_on = [
    resource.aws_redshift_cluster.cdcworkshop,
  ]
  provisioner "local-exec" {
    command = "./00_create_client.properties.sh ${aws_redshift_cluster.cdcworkshop.dns_name} ${var.rs_port} ${var.rs_master_username} ${var.rs_master_password} ${aws_redshift_cluster.cdcworkshop.database_name}"
  }
}