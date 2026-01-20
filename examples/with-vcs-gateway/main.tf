terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
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

  app_domain          = var.server_domain
  location            = var.location
  resource_group_name = "spacelift-vcs-gateway-${random_string.seed.result}"
  postgres_version    = var.postgres_version

  vcs_gateway_domain = var.vcs_gateway_domain
}
