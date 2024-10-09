# --------------------------------------------------------
# Connector
# --------------------------------------------------------
# MYSQL CDC 
resource "confluent_connector" "mysqlcdc" {
  environment {
    id = var.envid
  }
  kafka_cluster {
    id = var.clusterid
  }
  config_sensitive = {}
  config_nonsensitive = {
    "after.state.only"                  = "false"
    "connector.class"                   = "MySqlCdcSourceV2" 
    "name"                              = "MySqlCdcSourceV2Connector_0"
    "database.hostname"                 = var.host_name
    "database.include.list"             = "demo"
    "table.include.list"                = "demo.accounts"
    "database.user"                     = "debezium"
    "database.password"                 = "dbz"
    "database.port"                     = "3306"
    "database.ssl.mode"                 = "disabled"
    "kafka.auth.mode"                   = "SERVICE_ACCOUNT"
    "kafka.service.account.id"          = var.said
    "heartbeat.interval.ms"             = "0"
    "json.output.decimal.format"        = "BASE64"
    "decimal.handling.mode"             = "precise"
    "output.data.format"                = "AVRO"
    "output.key.format"                 = "AVRO"
    "schema.context.name"               = "default",
    "schema.history.internal.skip.unparseable.ddl" = "false"
    "schema.history.internal.store.only.captured.tables.ddl" = "false"
    "schema.name.adjustment.mode"       = "none"
    "field.name.adjustment.mode"        = "none"
    "event.processing.failure.handling.mode" = "fail"
    "inconsistent.schema.handling.mode" = "fail"
    "snapshot.locking.mode"             = "minimal"
    "snapshot.mode"                     = "initial"
    "tasks.max"                         = "1"
    "time.precision.mode"               = "adaptive_time_microseconds"
    "tombstones.on.delete"              = "true"
    "topic.prefix"                      = "mysql"
  }
  depends_on = [
  ]
  lifecycle {
    prevent_destroy = false
  }
}

