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
}
