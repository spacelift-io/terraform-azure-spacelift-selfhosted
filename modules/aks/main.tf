resource "azurerm_kubernetes_cluster" "self-hosted" {
  name                = "self-hosted"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  dns_prefix          = "spacelift${var.seed}"

  default_node_pool {
    name           = "default"
    node_count     = 3
    vm_size        = "Standard_A2_v2"
    vnet_subnet_id = var.subnet_id
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