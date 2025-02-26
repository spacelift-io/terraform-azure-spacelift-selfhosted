resource "azurerm_kubernetes_cluster" "self-hosted" {
  name                = "self-hosted"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  dns_prefix          = "spacelift${var.seed}"

  default_node_pool {
    name                        = var.default_node_pool.name
    temporary_name_for_rotation = var.default_node_pool.temporary_name_for_rotation
    auto_scaling_enabled        = true
    min_count                   = var.default_node_pool.min_count
    max_count                   = var.default_node_pool.max_count
    max_pods                    = var.default_node_pool.max_pods
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

  lifecycle {
    # Just to filter noise out of plans
    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#auto_scaling_enabled-1
    ignore_changes = [
      default_node_pool.0.node_count,
      default_node_pool.0.upgrade_settings,
    ]
  }

  tags = {
    Environment = "azure-self-hosted"
  }
}

resource "azurerm_public_ip" "ipv4" {
  name                = "ipv4"
  resource_group_name = azurerm_kubernetes_cluster.self-hosted.node_resource_group
  location            = var.resource_group.location
  allocation_method   = "Static"
  ip_version          = "IPv4"
  sku                 = "Standard"

  tags = {
    environment = "azure-self-hosted"
  }
}