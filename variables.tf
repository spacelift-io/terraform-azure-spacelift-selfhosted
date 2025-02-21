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

variable "subscription_id" {
  type        = string
  description = "The subscription ID that will be used to create a resource group"
}

variable "k8s_namespace" {
  type        = string
  default     = "spacelift"
  description = "The namespace in which the Spacelift backend service will be deployed"
}