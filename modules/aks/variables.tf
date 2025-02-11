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

variable "subnet_id" {
  type = string
}