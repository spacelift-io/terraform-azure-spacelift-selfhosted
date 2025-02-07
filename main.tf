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
  source                        = "./modules/container_registry"
  azure_resource_group_location = azurerm_resource_group.rg.location
  azure_resource_group_name     = azurerm_resource_group.rg.name
  seed                          = random_string.seed.result
}