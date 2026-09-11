terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>5.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}
