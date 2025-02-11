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

resource "azurerm_public_ip" "ipv4" {
  name                = "ipv4"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  allocation_method   = "Static"
  ip_version          = "IPv4"
  sku                 = "Standard"

  tags = {
    environment = "azure-self-hosted"
  }
}