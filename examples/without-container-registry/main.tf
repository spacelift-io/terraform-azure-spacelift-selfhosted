terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

variable "subscription_id" {
  type = string
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "random_string" "seed" {
  length  = 4
  special = false
  upper   = false
}


module "spacelift" {
  source = "../.."

  app_domain          = "spacelift.example.com"
  location            = "westeurope"
  resource_group_name = "self-hosted-v3-tf-testing-${random_string.seed.result}"
  postgres_version    = "17"

  create_container_registry = false
}

output "shell" {
  value     = module.spacelift.shell
  sensitive = true
}

output "kubernetes_secrets" {
  value     = module.spacelift.kubernetes_secrets
  sensitive = true
}

output "helm_values" {
  value = module.spacelift.helm_values
}

output "private_container_registry_name" {
  value = module.spacelift.private_container_registry_name
}

output "public_container_registry_name" {
  value = module.spacelift.public_container_registry_name
}
