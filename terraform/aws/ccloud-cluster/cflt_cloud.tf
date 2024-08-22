data "confluent_organization" "main" {}

data "confluent_flink_region" "main" {
  cloud        = var.cc_cloud_provider
  region       = var.cc_cloud_region
}

data "confluent_flink_region" "eu-central-1" {
  cloud  = var.cc_cloud_provider
  region = var.cc_cloud_region
}

# -------------------------------------------------------
# Confluent Cloud Environment
# -------------------------------------------------------
resource "confluent_environment" "cc_handson_env" {
  display_name = "${var.cc_env_name}-${random_id.id.hex}"
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Schema Registry
# --------------------------------------------------------
data "confluent_schema_registry_region" "advanced" {
  cloud   = var.cc_cloud_provider
  region  = var.cc_cloud_region
  package = var.sr_package
}

resource "confluent_schema_registry_cluster" "advanced" {
  package = data.confluent_schema_registry_region.advanced.package
  environment {
    id = confluent_environment.cc_handson_env.id
  }
  region {
    id = data.confluent_schema_registry_region.advanced.id
  }
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Confluent Cloud Kafka Cluster
# --------------------------------------------------------
resource "confluent_kafka_cluster" "cc_kafka_cluster" {
  display_name = "${var.cc_cluster_name}-${random_id.id.hex}"
  availability = var.cc_availability
  cloud        = var.cc_cloud_provider
  region       = var.cc_cloud_region
  basic {}
  environment {
    id = confluent_environment.cc_handson_env.id
  }
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Service Accounts (app_manager, sr, clients, connectors)
# --------------------------------------------------------
resource "confluent_service_account" "app_manager" {
  display_name = "cmapp-manager-${random_id.id.hex}"
  description  = local.description
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_service_account" "sr" {
  display_name = "cmsr-${random_id.id.hex}"
  description  = local.description
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_service_account" "clients" {
  display_name = "cmclient-${random_id.id.hex}"
  description  = local.description
  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_service_account" "connectors" {
  display_name = "cmconnectors-${random_id.id.hex}"
  description  = local.description
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Role Bindings (app_manager, sr, clients)
# --------------------------------------------------------
resource "confluent_role_binding" "app_manager_environment_admin" {
  principal   = "User:${confluent_service_account.app_manager.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.cc_handson_env.resource_name
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_role_binding" "app_manager_flinkdeveloper" {
  principal   = "User:${confluent_service_account.app_manager.id}"
  role_name   = "FlinkDeveloper"
  crn_pattern = confluent_environment.cc_handson_env.resource_name
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_role_binding" "app_manager_flinkadmin" {
  principal   = "User:${confluent_service_account.app_manager.id}"
  role_name   = "FlinkAdmin"
  crn_pattern = confluent_environment.cc_handson_env.resource_name
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_role_binding" "app_manager_assigner" {
  principal   = "User:${confluent_service_account.app_manager.id}"
  role_name   = "Assigner"
  crn_pattern = "${data.confluent_organization.ccloud.resource_name}/service-account=${confluent_service_account.app_manager.id}"
  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_role_binding" "sr_environment_admin" {
  principal   = "User:${confluent_service_account.sr.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.cc_handson_env.resource_name
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_role_binding" "connectors_cluster_admin" {
  principal   = "User:${confluent_service_account.connectors.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.cc_kafka_cluster.rbac_crn
  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_role_binding" "clients_cluster_admin" {
  principal   = "User:${confluent_service_account.clients.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.cc_kafka_cluster.rbac_crn
  lifecycle {
    prevent_destroy = false
  }
}
# --------------------------------------------------------
# Credentials / API Keys
# --------------------------------------------------------
# app_manager
resource "confluent_api_key" "app_manager_kafka_cluster_key" {
  display_name = "cmapp-manager-${var.cc_cluster_name}-key-${random_id.id.hex}"
  description  = local.description
  owner {
    id          = confluent_service_account.app_manager.id
    api_version = confluent_service_account.app_manager.api_version
    kind        = confluent_service_account.app_manager.kind
  }
  managed_resource {
    id          = confluent_kafka_cluster.cc_kafka_cluster.id
    api_version = confluent_kafka_cluster.cc_kafka_cluster.api_version
    kind        = confluent_kafka_cluster.cc_kafka_cluster.kind
    environment {
      id = confluent_environment.cc_handson_env.id
    }
  }
  depends_on = [
    confluent_role_binding.app_manager_environment_admin
  ]
  lifecycle {
    prevent_destroy = false
  }
}
# Schema Registry
resource "confluent_api_key" "sr_cluster_key" {
  display_name = "cmsr-${var.cc_cluster_name}-key-${random_id.id.hex}"
  description  = local.description
  owner {
    id          = confluent_service_account.sr.id
    api_version = confluent_service_account.sr.api_version
    kind        = confluent_service_account.sr.kind
  }
  managed_resource {
    id          = confluent_schema_registry_cluster.advanced.id
    api_version = confluent_schema_registry_cluster.advanced.api_version
    kind        = confluent_schema_registry_cluster.advanced.kind
    environment {
      id = confluent_environment.cc_handson_env.id
    }
  }
  depends_on = [
    confluent_role_binding.sr_environment_admin
  ]
  lifecycle {
    prevent_destroy = false
  }
}
# Kafka clients
resource "confluent_api_key" "clients_kafka_cluster_key" {
  display_name = "clients-${var.cc_cluster_name}-key-${random_id.id.hex}"
  description  = local.description
  owner {
    id          = confluent_service_account.clients.id
    api_version = confluent_service_account.clients.api_version
    kind        = confluent_service_account.clients.kind
  }
  managed_resource {
    id          = confluent_kafka_cluster.cc_kafka_cluster.id
    api_version = confluent_kafka_cluster.cc_kafka_cluster.api_version
    kind        = confluent_kafka_cluster.cc_kafka_cluster.kind
    environment {
      id = confluent_environment.cc_handson_env.id
    }
  }
  depends_on = [
    confluent_role_binding.clients_cluster_admin
  ]
  lifecycle {
    prevent_destroy = false
  }
}

# connectors
resource "confluent_api_key" "connector_key" {
  display_name = "connector-${var.cc_cluster_name}-key-${random_id.id.hex}"
  description  = local.description
  owner {
    id          = confluent_service_account.connectors.id
    api_version = confluent_service_account.connectors.api_version
    kind        = confluent_service_account.connectors.kind
  }
  managed_resource {
    id          = confluent_kafka_cluster.cc_kafka_cluster.id
    api_version = confluent_kafka_cluster.cc_kafka_cluster.api_version
    kind        = confluent_kafka_cluster.cc_kafka_cluster.kind
    environment {
      id = confluent_environment.cc_handson_env.id
    }
  }
  depends_on = [
    confluent_role_binding.connectors_cluster_admin,
  ]
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Flink API Keys
# --------------------------------------------------------
resource "confluent_api_key" "env-manager-flink-api-key" {
  display_name = "app-manager-flink-api-key-${random_id.id.hex}"
  description  = "Flink API Key that is owned by 'env-manager' service account"
  owner {
    id          = confluent_service_account.app_manager.id
    api_version = confluent_service_account.app_manager.api_version
    kind        = confluent_service_account.app_manager.kind
  }

  managed_resource {
    id          = data.confluent_flink_region.eu-central-1.id
    api_version = data.confluent_flink_region.eu-central-1.api_version
    kind        = data.confluent_flink_region.eu-central-1.kind

    environment {
      id = confluent_environment.cc_handson_env.id
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Create Kafka topics for the Salesforce CDC Connector
# --------------------------------------------------------
resource "confluent_kafka_topic" "salesforce_contacts" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  topic_name    = "salesforce_contacts"
  partitions_count   = 1
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Create schema for the Salesforce CDC Connector topic salesforce_contacts
# --------------------------------------------------------
resource "confluent_schema" "avro-salesforce_contacts" {
  schema_registry_cluster {
    id =confluent_schema_registry_cluster.advanced.id
  }
  rest_endpoint = confluent_schema_registry_cluster.advanced.rest_endpoint
  subject_name = "salesforce_contacts-value"
  format = "AVRO"
  schema = file("./schema/schema-salesforce_contacts-value-v1.avsc")
  credentials {
    key    = confluent_api_key.sr_cluster_key.id
    secret = confluent_api_key.sr_cluster_key.secret
  }

  depends_on = [
    confluent_api_key.sr_cluster_key,
  ]

  lifecycle {
    prevent_destroy = false
  }
}


# --------------------------------------------------------
# Create Tags
# --------------------------------------------------------
resource "confluent_tag" "pii" {
  schema_registry_cluster {
    id = confluent_schema_registry_cluster.advanced.id
  }
  rest_endpoint = confluent_schema_registry_cluster.advanced.rest_endpoint
  credentials {
    key    = confluent_api_key.sr_cluster_key.id
    secret = confluent_api_key.sr_cluster_key.secret
  }

  name = "PII"
  description = "PII tag"

  depends_on = [
    confluent_api_key.sr_cluster_key,
  ]

  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_tag" "public" {
  schema_registry_cluster {
    id = confluent_schema_registry_cluster.advanced.id
  }
  rest_endpoint = confluent_schema_registry_cluster.advanced.rest_endpoint
  credentials {
    key    = confluent_api_key.sr_cluster_key.id
    secret = confluent_api_key.sr_cluster_key.secret
  }

  name = "Public"
  description = "Public tag"

depends_on = [
    confluent_api_key.sr_cluster_key,
  ]

  lifecycle {
    prevent_destroy = false
  }
}
# --------------------------------------------------------
# Bind Tags to Topics
# --------------------------------------------------------
resource "confluent_tag_binding" "salesforce_contacts" {
  schema_registry_cluster {
    id = confluent_schema_registry_cluster.advanced.id
  }
  rest_endpoint = confluent_schema_registry_cluster.advanced.rest_endpoint
  credentials {
    key    = confluent_api_key.sr_cluster_key.id
    secret = confluent_api_key.sr_cluster_key.secret
  }

  tag_name = "PII"
  entity_name = "${confluent_schema_registry_cluster.advanced.id}:${confluent_kafka_cluster.cc_kafka_cluster.id}:${confluent_kafka_topic.salesforce_contacts.topic_name}"
  entity_type = "kafka_topic"

depends_on = [
    confluent_api_key.sr_cluster_key,
    confluent_tag.pii,
  ]

  lifecycle {
    prevent_destroy = false
  }
}