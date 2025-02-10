resource "azurerm_container_registry" "self_hosted" {
  name                = "selfhosted${var.seed}"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  sku                 = "Standard"
}

resource "azurerm_container_registry" "self_hosted_public" {
  name                   = "selfhostedpublic${var.seed}"
  resource_group_name    = var.resource_group.name
  location               = var.resource_group.location
  sku                    = "Standard"
  anonymous_pull_enabled = true
}
