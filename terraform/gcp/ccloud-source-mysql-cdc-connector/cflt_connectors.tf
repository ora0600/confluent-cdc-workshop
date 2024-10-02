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
    "database.password"                 = "dbz"
    "database.port"                     = "3306"
    "database.ssl.mode"                 = "disabled"
    "database.user"                     = "debezium"
    "decimal.handling.mode"             = "precise"
    "event.processing.failure.handling.mode" = "fail"
    "field.name.adjustment.mode"        = "none"
    "heartbeat.interval.ms"             = "0"
    "inconsistent.schema.handling.mode" = "fail"
    "json.output.decimal.format"        = "BASE64"
    "kafka.auth.mode"                   = "SERVICE_ACCOUNT"
    "kafka.service.account.id"          = var.said
    "output.data.format"                = "AVRO"
    "output.key.format"                 = "AVRO"
    "schema.context.name"               = "default",
    "schema.history.internal.skip.unparseable.ddl" = "false"
    "schema.history.internal.store.only.captured.tables.ddl" = "false"
    "schema.name.adjustment.mode"       = "none"
    "snapshot.locking.mode"             = "minimal"
    "snapshot.mode"                     = "initial"
    "table.include.list"                = "demo.accounts"
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

