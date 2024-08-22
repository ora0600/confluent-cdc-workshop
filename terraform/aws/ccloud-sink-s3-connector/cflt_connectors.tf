# --------------------------------------------------------
# Connector
# --------------------------------------------------------
# S3 Sink
resource "confluent_connector" "s3sink" {
  environment {
    id = var.envid
  }
  kafka_cluster {
    id = var.clusterid
  }
  config_sensitive = {}
  config_nonsensitive = {
    "name"                          = "S3_SINKConnector_0"
    "connector.class"               = "S3_SINK"
    "topics"                        = "all_products"
    "kafka.auth.mode"               = "SERVICE_ACCOUNT"
    "kafka.service.account.id"      = var.said
    "aws.access.key.id"             = var.aws_access_key
    "aws.secret.access.key"         = var.aws_secret_key
    "s3.region"                     = var.aws_region
    "s3.bucket.name"                = var.bucket_name
    "schema.context.name"           = "default"
    "input.data.format"             = "AVRO"
    "output.data.format"            = "AVRO"
    "s3.part.size"                  = "5242880"
    "s3.wan.mode"                   = "false"
    "s3.path.style.access.enabled"  = "true"
    "topics.dir"                    = "topics"
    "path.format"                   = "'year'=YYYY/'month'=MM/'day'=dd/'hour'=HH"
    "time.interval"                 = "HOURLY"
    "rotate.schedule.interval.ms"   = "-1"
    "flush.size"                    = "1000"
    "behavior.on.null.values"       = "ignore"
    "timezone"                      = "UTC"
    "subject.name.strategy"         = "TopicNameStrategy"
    "tombstone.encoded.partition"   = "tombstone"
    "enhanced.avro.schema.support"  = "true"
    "locale"                        = "en"
    "s3.schema.partition.affix.type"= "NONE"
    "schema.compatibility"          = "NONE"
    "store.kafka.keys"              = "false"
    "value.converter.connect.meta.data" = "true"
    "store.kafka.headers"          = "false"
    "s3.object.tagging"            = "false"
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

