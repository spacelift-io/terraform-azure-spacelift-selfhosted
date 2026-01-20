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

variable "postgres_version" {
  type        = string
  description = "PostgreSQL major version for the flexible server. Example values include '15', '16', '17'."
}

variable "k8s_default_node_pool" {
  type = object({
    name                        = optional(string, "default")
    temporary_name_for_rotation = optional(string)
    min_count                   = optional(number, 1)
    max_count                   = optional(number, 3)
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
      min_count : "The minimum number of nodes which should exist in this Node Pool"
      max_count : "The maximum number of nodes which should exist in this Node Pool"
      max_pods: "The maximum number of pods that can run on each node"
      vm_size : "The size of the Virtual Machine"
      upgrade_settings_max_surge : "The maximum number or percentage of nodes which will be added to the Node Pool size during an upgrade"
  }
  EOT
}

variable "license_token" {
  type        = string
  description = "The JWT token for using Spacelift. Only required for generating the kubernetes_secrets output. It can be ignored if you are not using that output."
  default     = ""
  sensitive   = true
}

variable "encryption_rsa_private_key" {
  type        = string
  description = "The RSA private key of the Spacelift instance. Only required for generating the kubernetes_secrets output. It can be ignored if you are not using that output."
  default     = ""
  sensitive   = true
}

variable "spacelift_public_api" {
  type        = string
  description = "The public API to use when sending usage data. Only required for generating the kubernetes_secrets output. It can be ignored if you are not using that output."
  default     = ""
}

variable "spacelift_version" {
  type        = string
  description = "The version of Spacelift being installed. Only required for generating the kubernetes_secrets output. It can be ignored if you are not using that output."
  default     = ""
}

variable "admin_username" {
  type        = string
  description = "The username for the Spacelift admin account. Only required for generating the kubernetes_secrets output. It can be ignored if you are not using that output."
  default     = ""
}

variable "admin_password" {
  type        = string
  description = "The password for the Spacelift admin account. Only required for generating the kubernetes_secrets output. It can be ignored if you are not using that output."
  default     = ""
  sensitive   = true
}

variable "vcs_gateway_domain" {
  type        = string
  description = "Domain for the VCS Gateway endpoint (e.g., vcs-gateway.spacelift.mycompany.com). Leave empty to disable VCS Gateway."
  default     = ""
}
