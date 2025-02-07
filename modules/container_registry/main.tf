resource "azurerm_container_registry" "self_hosted" {
  name                = "selfhosted${var.seed}"
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_resource_group_location
  sku                 = "Standard"
  admin_enabled       = true
}

#

resource "azurerm_container_registry" "self_hosted_public" {
  name                   = "selfhostedpublic${var.seed}"
  resource_group_name    = var.azure_resource_group_name
  location               = var.azure_resource_group_location
  sku                    = "Standard"
  admin_enabled          = true
  anonymous_pull_enabled = true
}
