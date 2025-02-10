resource "azurerm_virtual_network" "spacelift" {
  name                = "spacelift-vnet"
  address_space       = ["10.30.0.0/16"]
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

resource "azurerm_subnet" "spacelift" {
  name                 = "spacelift-subnet"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.spacelift.name
  address_prefixes     = ["10.30.1.0/24"]
}
