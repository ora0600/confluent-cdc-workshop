# --------------------------------------------------------
# Connectors
# --------------------------------------------------------
# Salesforce CDC 
resource "confluent_connector" "salesforcecdc" {
  environment {
    id = var.envid
  }
  kafka_cluster {
    id = var.clusterid
  }
  config_sensitive = {}
  config_nonsensitive = {
    "connector.class"             = "SalesforceCdcSource"
    "name"                        = "SFCDC_contacts"
    "kafka.auth.mode"             = "SERVICE_ACCOUNT"
    "kafka.service.account.id"    = var.said
    "kafka.topic"                 = "salesforce_contacts"
    "schema.context.name"         = "default"
    "salesforce.grant.type"       = "PASSWORD"
    "salesforce.instance"         = "https://login.salesforce.com"
    "salesforce.channel.type"     = "SINGLE"
    "salesforce.initial.start"    = "latest"
    "request.max.retries.time.ms" = "30000"
    "connection.max.message.size" = "1048576"
    "output.data.format"          = "AVRO"
    "tasks.max"                   = "1"
    "salesforce.username"         = var.sf_user
    "salesforce.password"         = var.sf_password
    "salesforce.cdc.name"         = var.sf_cdc_name
    "salesforce.password.token"   = var.sf_password_token
    "salesforce.consumer.key"     = var.sf_consumer_key
    "salesforce.consumer.secret"  = var.sf_consumer_secret
  }
  depends_on = [
  ]
  lifecycle {
    prevent_destroy = false
  }
}