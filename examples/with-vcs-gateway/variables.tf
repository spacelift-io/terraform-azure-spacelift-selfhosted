variable "subscription_id" {
  type        = string
  description = "Azure subscription ID to deploy resources into."
}

variable "location" {
  type        = string
  description = "Azure region to deploy resources into."
}

variable "server_domain" {
  type        = string
  description = "The domain that Spacelift is being hosted on without protocol and port. Eg.: 'spacelift.mycorp.io'."
}

variable "postgres_version" {
  type        = string
  description = "PostgreSQL major version for the flexible server."
}

variable "vcs_gateway_domain" {
  type        = string
  description = "The domain for the VCS Gateway external endpoint without protocol and port. Eg.: 'vcs-gateway.mycorp.io'."
}
