variable "seed" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "flexible_server_sku_name" {
  type = string
}

variable "virtual_network" {
  type = object({
    id : string
    name : string
  })
  description = "Azure virtual network for database deployment."
}

variable "k8s_pods_cidr" {
  type = string
}

variable "resource_group" {
  type = object({
    name : string
    location : string
  })
  description = "Azure resource group that will be used for the registries."
}