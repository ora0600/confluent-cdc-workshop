# --------------------------------------------------------
# Connector
# --------------------------------------------------------
# Redshift Sink
resource "confluent_connector" "redshiftsink" {
  environment {
    id = var.envid
  }
  kafka_cluster {
    id = var.clusterid
  }
  config_sensitive = {}
  config_nonsensitive = {
    "connector.class"                       = "RedshiftSink"
    "name"                                  = "RedshiftSinkConnector_0"
    "schema.context.name"                   = "default"
    "input.data.format"                     = "AVRO"
    "kafka.auth.mode"                       = "SERVICE_ACCOUNT"
    "kafka.service.account.id"              = var.said
    "topics"                                = "all_contacts"
    "aws.redshift.domain"                   = var.rsdomain
    "aws.redshift.port"                     = var.rsport
    "aws.redshift.user"                     = var.rsuser
    "aws.redshift.password"                 = var.rspassword
    "aws.redshift.database"                 = var.rsdbname
    "db.timezone"                           = "UTC"
    "batch.size"                            = "3000"
    "auto.create"                           = "true"
    "auto.evolve"                           = "true"
    "max.poll.interval.ms"                  = "300000"
    "max.poll.records"                      = "500"
    "tasks.max"                             = "1"
  }
  depends_on = [
  ]
  lifecycle {
    prevent_destroy = false
  }
}

