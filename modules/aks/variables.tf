variable "seed" {
  type = string
}

variable "resource_group" {
  type = object({
    name : string
    location : string
  })
  description = "Azure resource group that will be used for the registries."
}

variable "subnet_id" {
  type = string
}

variable "node_count" {
  default = 3
}

variable "vm_size" {
  default = "Standard_A2_v2"
}

variable "default_node_pool" {
  type = object({
    name                        = optional(string, "default")
    temporary_name_for_rotation = optional(string)
    node_count                  = optional(number, 3)
    min_count                   = optional(number)
    max_count                   = optional(number)
    vm_size                     = optional(string, "Standard_A2_v2")
    auto_scaling_enabled        = optional(bool, false)
    vnet_subnet_id              = string
    upgrade_settings_max_surge  = optional(string, "10")
  })
}