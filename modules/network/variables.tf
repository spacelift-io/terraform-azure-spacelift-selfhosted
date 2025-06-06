variable "resource_group" {
  type = object({
    name : string
    location : string
  })
  description = "Azure resource group that will be used for the registries."
}