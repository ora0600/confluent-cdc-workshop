# --------------------------------------------------------
# Connector
# --------------------------------------------------------
# S3 Sink
resource "confluent_connector" "storagesink" {
  environment {
    id = var.envid
  }
  kafka_cluster {
    id = var.clusterid
  }
  config_sensitive = {}
  config_nonsensitive = {
    "name"                          = "AllProductsGcsSinkConnector_0"
    "connector.class"               = "GcsSink"
    "topics"                        = "all_products"
    "kafka.auth.mode"               = "SERVICE_ACCOUNT"
    "kafka.service.account.id"      = var.said
    "gcs.credentials.config"        = file("${var.gcp_credentials}")
    "gcs.bucket.name"                = var.bucket_name
    "schema.context.name"           = "default"
    "input.data.format"             = "AVRO"
    "output.data.format"            = "AVRO"
    "gcs.compression.type"          = "none"
    "gcs.part.size"                 = "5242880"
    "topics.dir"                    = "topics"
    "path.format"                   = "'year'=YYYY/'month'=MM/'day'=dd/'hour'=HH"
    "time.interval"                 = "HOURLY"
    "rotate.schedule.interval.ms"   = "600000"
    "rotate.interval.ms"            = "600000"
    "flush.size"                    = "1000"
    "behavior.on.null.values"       = "ignore"
    "timezone"                      = "UTC"
    "subject.name.strategy"         = "TopicNameStrategy"
    "tombstone.encoded.partition"   = "tombstone"
    "enhanced.avro.schema.support"  = "true"
    "locale"                        = "en"
    "schema.compatibility"          = "NONE"
    "value.converter.connect.meta.data" = "true"
    "max.poll.interval.ms"         = "300000"
    "max.poll.records"             = "500"
    "tasks.max"                    = "1"
  }
  depends_on = [
  ]
  lifecycle {
    prevent_destroy = false
  }
}

