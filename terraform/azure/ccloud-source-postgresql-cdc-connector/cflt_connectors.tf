# --------------------------------------------------------
# Connector
# --------------------------------------------------------
# postgres CDC 
resource "confluent_connector" "postgrescdc" {
  environment {
    id = var.envid
  }
  kafka_cluster {
    id = var.clusterid
  }
  config_sensitive = {}
  config_nonsensitive = {
    "after.state.only"                        = "false"
    "connector.class"                         = "PostgresCdcSourceV2"
    "name"                                    = "PostgresCdcSourceV2Connector_0"
    "database.dbname"                         = "customers"
    "database.hostname"                       = var.host_name
    "database.password"                       = "postgres-pw"
    "database.port"                           = "5432"
    "database.sslmode"                        = "disable"
    "database.user"                           = "postgres-user"
    "decimal.handling.mode"                   = "precise"
    "event.processing.failure.handling.mode"  = "fail"
    "field.name.adjustment.mode"              = "none"
    "heartbeat.interval.ms"                   = "0"
    "json.output.decimal.format"              = "BASE64"
    "kafka.auth.mode"                         = "SERVICE_ACCOUNT"
    "kafka.service.account.id"                = var.said
    "output.data.format"                      = "AVRO"
    "output.key.format"                       = "AVRO"
    "publication.autocreate.mode"             = "all_tables"
    "publication.name"                        = "dbz_publication"
    "schema.context.name"                     = "default"
    "schema.name.adjustment.mode"             = "none"
    "slot.name"                               = "debezium"
    "snapshot.mode"                           = "initial"
    "tasks.max"                               = "1"
    "time.precision.mode"                     = "adaptive"
    "tombstones.on.delete"                    = "true"
    "topic.prefix"                            = "postgres"
  }
  depends_on = [
  ]
  lifecycle {
    prevent_destroy = false
  }
}

