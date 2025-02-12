variable "seed" {
  type = string
}

variable "app_domain" {
  type = string
}

variable "resource_group" {
  type = object({
    name: string
    location: string
  })
  description = "Azure resource group that will be used for the registries."
}

variable "kubernetes_object_id" {
  type = string
}