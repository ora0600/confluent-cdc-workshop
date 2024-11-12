# --------------------------------------------------------
# Connector
# --------------------------------------------------------
# Oracle CDC 
resource "confluent_connector" "oraclecdc" {
  environment {
    id = var.envid
  }
  kafka_cluster {
    id = var.clusterid
  }
  config_sensitive = {}
  config_nonsensitive = {
    "connector.class"                   = "OracleCdcSource"
    "name"                              = "oracle21-cdc-connector"
    "kafka.auth.mode"                   = "SERVICE_ACCOUNT"
    "kafka.service.account.id"          = var.said
    "schema.context.name"               = "default"
    "oracle.server"                     = var.oracle_host
    "oracle.port"                       = "1521"
    "oracle.sid"                        = "XE"
    "oracle.pdb.name"                   = "XEPDB1"
    "oracle.service.name"               = "XE"
    "oracle.username"                   = "C##MYUSER"
    "oracle.password"                   = "confluent123"
    "oracle.fan.events.enable"          = "false"
    "table.inclusion.regex"             = "XEPDB1[.]ORDERMGMT[.](ORDER_ITEMS|ORDERS|EMPLOYEES|PRODUCTS|CUSTOMERS|INVENTORIES|PRODUCT_CATEGORIES|CONTACTS|NOTES|WAREHOUSES|LOCATIONS|COUNTRIES|REGIONS)"
    "start.from"                        = "snapshot"
    "oracle.supplemental.log.level"     = "full"
    "emit.tombstone.on.delete"          = "false"
    "behavior.on.dictionary.mismatch"   = "fail"
    "behavior.on.unparsable.statement"  = "fail"
    "db.timezone"                       = "UTC"
    "redo.log.startup.polling.limit.ms" = "300000"
    "heartbeat.interval.ms"             = "300000"
    "log.mining.end.scn.deviation.ms"   = "0"
    "use.transaction.begin.for.mining.session" = "false"
    "log.mining.transaction.age.threshold.ms"  = "-1"
    "log.mining.transaction.threshold.breached.action" = "warn"
#    "use.transaction.begin.for.mining.session" = "true"
#    "log.mining.transaction.age.threshold.ms"  = "300000" # 5 minutes
#    "log.mining.transaction.threshold.breached.action" = "discard"
    "query.timeout.ms"                  = "300000"
    "max.batch.size"                    = "1000"
    "poll.linger.ms"                    = "5000"
    "max.buffer.size"                   = "0"
    "redo.log.poll.interval.ms"         = "500"
    "snapshot.row.fetch.size"           = "2000"
    "redo.log.row.fetch.size"           = "5000"
    "oracle.validation.result.fetch.size" =  "5000"
    "redo.log.topic.name"               = "XEPDB1.ORDERMGMT.REDOLOG"
    "oracle.dictionary.mode"            = "auto"
    "snapshot.by.table.partitions"      = "false"
    "snapshot.threads.per.task"         = "4"
    "enable.large.lob.object.support"   = "false"
    "numeric.mapping"                   = "best_fit_or_double"
    "numeric.default.scale"             = "127"
    "oracle.date.mapping"               = "timestamp"
    "output.data.key.format"            = "AVRO"
    "output.data.value.format"          = "AVRO"
    "tasks.max"                         = "1"
  }
  depends_on = [
  ]
  lifecycle {
    prevent_destroy = false
  }
}

