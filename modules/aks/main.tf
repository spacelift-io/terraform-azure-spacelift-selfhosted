resource "azurerm_kubernetes_cluster" "self-hosted" {
  name                = "self-hosted"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  dns_prefix          = "spacelift${var.seed}"

  default_node_pool {
    name                        = var.default_node_pool.name
    temporary_name_for_rotation = var.default_node_pool.temporary_name_for_rotation
    node_count                  = var.default_node_pool.node_count
    min_count                   = var.default_node_pool.min_count
    max_count                   = var.default_node_pool.max_count
    vm_size                     = var.default_node_pool.vm_size
    vnet_subnet_id              = var.default_node_pool.vnet_subnet_id
    upgrade_settings {
      max_surge = var.default_node_pool.upgrade_settings_max_surge
    }
  }
  network_profile {
    ip_versions         = ["IPv4"]
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    pod_cidr            = "10.244.0.0/20"
    service_cidr        = "10.0.0.0/22"
    dns_service_ip      = "10.0.0.10"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "azure-self-hosted"
  }
}
