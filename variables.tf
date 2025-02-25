variable "location" {
  type        = string
  description = "The location in which the resources will be created"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name that will used for the created resources"
}

variable "app_domain" {
  type        = string
  description = "The domain under which the Spacelift instance will be hosted"
}

variable "subscription_id" {
  type        = string
  description = "The subscription ID that will be used to create a resource group"
}

variable "k8s_namespace" {
  type        = string
  default     = "spacelift"
  description = "The namespace in which the Spacelift backend service will be deployed"
}

variable "db_sku_name" {
  type        = string
  default     = "B_Standard_B2s"
  description = "The SKU name of the postgres flexible server"
}

variable "k8s_default_node_pool" {
  type = object({
    name                        = optional(string, "default")
    temporary_name_for_rotation = optional(string)
    node_count                  = optional(number, 3)
    min_count                   = optional(number)
    max_count                   = optional(number)
    max_pods                    = optional(number)
    vm_size                     = optional(string, "Standard_A2_v2")
    auto_scaling_enabled        = optional(bool, false)
    upgrade_settings_max_surge  = optional(string, "10")
  })
  default     = {}
  description = <<-EOT
  {
      name : "The name of the default k8s node pool"
      temporary_name_for_rotation : "Specifies the name of the temporary node pool used to cycle the default node pool for VM resizing"
      node_count : "The initial number of nodes which should exist in this Node Pool"
      min_count : "The minimum number of nodes which should exist in this Node Pool"
      max_count : "The maximum number of nodes which should exist in this Node Pool"
      max_pods: "The maximum number of pods that can run on each node"
      vm_size : "The size of the Virtual Machine"
      auto_scaling_enabled : "Defines if the autoscaler should be enabled"
      upgrade_settings_max_surge : "The maximum number or percentage of nodes which will be added to the Node Pool size during an upgrade"
  }
  EOT
}