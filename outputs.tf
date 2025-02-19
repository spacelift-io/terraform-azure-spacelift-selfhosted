output "location" {
  value       = var.location
  description = "The location the Spacelift infrastructure is deployed in"
}

output "resource_group_name" {
  value       = var.resource_group_name
  description = "The resource group the Spacelift infrastructure is deployed in"
}


### Network ###
output "aks_public_v4_address" {
  value       = module.network.public_ip_address
  description = "Public IPv4 address for AKS Ingresses"
}

output "virtual_network_id" {
  value       = module.network.virtual_network.id
  description = "ID of the virtual network that is used to deploy Spacelift"
}

output "subnet_id" {
  value       = module.network.subnet.id
  description = "ID of the subnet that is used for the Spacelift AKS cluster"
}

### Database ###

output "db_root_password" {
  value       = module.postgres.postgres_password
  description = "The database root password"
  sensitive   = true
}


output "db_name" {
  value       = module.postgres.postgres_name
  description = "The name of the postgres server"
}

### Storage ###
output "container_storage_account_name" {
  value       = module.container_storage.storage_account_name
  description = "The name of the storage account"
}

output "large_queue_messages_bucket" {
  value       = module.container_storage.large_queue_messages_container
  description = "Name of the bucket used for storing large queue messages"
}

output "metadata_bucket" {
  value       = module.container_storage.metadata_container
  description = "Name of the bucket used for storing run metadata"
}

output "modules_bucket" {
  value       = module.container_storage.modules_container
  description = "Name of the bucket used for storing Spacelift modules"
}

output "policy_inputs_bucket" {
  value       = module.container_storage.policy_inputs_container
  description = "Name of the bucket used for storing policy inputs"
}

output "run_logs_bucket" {
  value       = module.container_storage.run_logs_container
  description = "Name of the bucket used for storing run logs"
}

output "states_bucket" {
  value       = module.container_storage.states_container
  description = "Name of the bucket used for storing stack states"
}

output "uploads_bucket" {
  value       = module.container_storage.uploads_container
  description = "Name of the bucket used for storing user uploads"
}

output "user_uploaded_workspaces_bucket" {
  value       = module.container_storage.user_uploaded_workspaces_container
  description = "Name of the bucket used for storing user uploaded workspaces. This is used for the local preview feature."
}

output "workspace_bucket" {
  value       = module.container_storage.workspaces_container
  description = "Name of the bucket used for storing stack workspace data"
}

output "deliveries_bucket" {
  value       = module.container_storage.deliveries_container
  description = "Name of the bucket used for storing audit trail delivery data"
}

### Container registry ###

output "public_container_registry_name" {
  value       = module.container_registry.public_registry_name
  description = "Name of the public container registry"
}

output "private_container_registry_name" {
  value       = module.container_registry.public_registry_name
  description = "Name of the private container registry"
}

### AKS ###
output "aks_cluster_name" {
  value       = module.aks.cluster_name
  description = "Name of the AKS cluster"
}

output "shell" {
  sensitive = true
  value = templatefile("${path.module}/env.tftpl", {
    env : {
      AZURE_SUBSCRIPTION_ID : var.subscription_id,
      AZURE_LOCATION : var.location,
      AZURE_RESOURCE_GROUP_NAME : var.resource_group_name,
      SERVER_DOMAIN : var.app_domain,
      WEBHOOKS_ENDPOINT : "https://${var.app_domain}/webhooks",

      # Network
      PUBLIC_IP_ADDRESS : module.network.public_ip_address,

      # Container registry
      PRIVATE_CONTAINER_REGISTRY_NAME : module.container_registry.private_registry_name,
      PUBLIC_CONTAINER_REGISTRY_NAME : module.container_registry.public_registry_name,
      BACKEND_IMAGE : "${module.container_registry.private_registry_url}/spacelift-backend",
      LAUNCHER_IMAGE : "${module.container_registry.public_registry_url}/spacelift-launcher",

      # Buckets
      OBJECT_STORAGE_BUCKET_DELIVERIES               = module.container_storage.deliveries_container,
      OBJECT_STORAGE_BUCKET_LARGE_QUEUE_MESSAGES     = module.container_storage.large_queue_messages_container,
      OBJECT_STORAGE_BUCKET_MODULES                  = module.container_storage.modules_container,
      OBJECT_STORAGE_BUCKET_POLICY_INPUTS            = module.container_storage.policy_inputs_container,
      OBJECT_STORAGE_BUCKET_RUN_LOGS                 = module.container_storage.run_logs_container,
      OBJECT_STORAGE_BUCKET_STATES                   = module.container_storage.states_container,
      OBJECT_STORAGE_BUCKET_USER_UPLOADED_WORKSPACES = module.container_storage.user_uploaded_workspaces_container,
      OBJECT_STORAGE_BUCKET_WORKSPACE                = module.container_storage.workspaces_container,
      OBJECT_STORAGE_BUCKET_METADATA                 = module.container_storage.metadata_container,
      OBJECT_STORAGE_BUCKET_UPLOADS                  = module.container_storage.uploads_container,

      # Database
      DB_CONNECTION_URL = "postgres://postgres:${urlencode(module.postgres.postgres_password)}@${module.postgres.postgres_address}/postgres?sslmode=verify-full",

      #AKS
      AKS_CLUSTER_NAME     = module.aks.cluster_name,
      K8S_NAMESPACE        = var.k8s_namespace,
      MQTT_BROKER_ENDPOINT = "spacelift-mqtt.${var.k8s_namespace}.svc.cluster.local.",
      STORAGE_ACCOUNT_URL  = module.container_storage.storage_account_url
    },
  })
}