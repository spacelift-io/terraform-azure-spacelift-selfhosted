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