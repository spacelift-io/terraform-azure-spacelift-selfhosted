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

variable "number_of_images_to_retain" {
  type = number
}

variable "node_principal_id" {
  type = string
}