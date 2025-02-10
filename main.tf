resource "random_string" "seed" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.resource_group_name
}

module "container_registry" {
  source         = "./modules/container_registry"
  seed           = random_string.seed.result
  resource_group = azurerm_resource_group.rg
}