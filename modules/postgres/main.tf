resource "azurerm_subnet" "postgres" {
  name                 = "spacelift-subnet-postgres"
  resource_group_name  = var.resource_group.name
  virtual_network_name = var.virtual_network.name
  address_prefixes     = ["10.30.0.0/24"]

  service_endpoints = ["Microsoft.Storage"]

  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_network_security_group" "default" {
  name                = "spacelift-nsg"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  security_rule {
    name                       = "alltraffic"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.k8s_pods_cidr
    destination_address_prefix = "*"
  }
}


resource "azurerm_private_dns_zone" "spacelift-postgres" {
  name                = "spacelift${var.seed}.postgres.database.azure.com"
  resource_group_name = var.resource_group.name

  depends_on = [azurerm_subnet_network_security_group_association.spacelift-postgres]
}

resource "azurerm_subnet_network_security_group_association" "spacelift-postgres" {
  subnet_id                 = azurerm_subnet.postgres.id
  network_security_group_id = azurerm_network_security_group.default.id
}


resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = "spacelift${var.seed}-pdzvnetlink.com"
  private_dns_zone_name = azurerm_private_dns_zone.spacelift-postgres.name
  virtual_network_id    = var.virtual_network.id
  resource_group_name   = var.resource_group.name
}

resource "random_password" "db-root-password" {
  length = 20
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                          = "spacelift-psql-${var.seed}"
  location                      = var.resource_group.location
  resource_group_name           = var.resource_group.name
  private_dns_zone_id           = azurerm_private_dns_zone.spacelift-postgres.id
  sku_name                      = var.flexible_server_sku_name
  storage_mb                    = 32768
  version                       = "14"
  public_network_access_enabled = false

  delegated_subnet_id    = azurerm_subnet.postgres.id
  administrator_login    = "postgres"
  administrator_password = random_password.db-root-password.result

  authentication {
    active_directory_auth_enabled = true
    tenant_id                     = var.tenant_id
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.default]

  lifecycle {
    ignore_changes = [zone]
  }
}

resource "azurerm_postgresql_flexible_server_configuration" "max_connections" {
  name      = "max_connections"
  server_id = azurerm_postgresql_flexible_server.postgres.id
  value     = "200"
}
