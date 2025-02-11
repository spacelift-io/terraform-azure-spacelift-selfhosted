variable "seed" {
  type = string
}

variable "resource_group" {
  type = object({
    name: string
    location: string
  })
  description = "Azure resource group that will be used for the registries."
}

variable "postgres_password" {
  type = string
}

variable "client_config" {
  type = object({
    tenant_id = string
    object_id = string
  })
}