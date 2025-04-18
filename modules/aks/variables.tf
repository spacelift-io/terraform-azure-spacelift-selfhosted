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

variable "default_node_pool" {
  type = object({
    name                        = string
    temporary_name_for_rotation = optional(string)
    min_count                   = optional(number)
    max_count                   = optional(number)
    max_pods                    = optional(number)
    vm_size                     = string
    vnet_subnet_id              = string
    upgrade_settings_max_surge  = string
  })
}