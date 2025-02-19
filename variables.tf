variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "app_domain" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "k8s_namespace" {
  type = string
  default = "spacelift"
}