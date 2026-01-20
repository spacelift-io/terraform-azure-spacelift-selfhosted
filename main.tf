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
  source            = "./modules/container_registry"
  seed              = random_string.seed.result
  resource_group    = azurerm_resource_group.rg
  node_principal_id = module.aks.node_principal_id
}


module "container_storage" {
  source               = "./modules/container_storage"
  seed                 = random_string.seed.result
  resource_group       = azurerm_resource_group.rg
  app_domain           = var.app_domain
  kubernetes_object_id = module.aks.node_principal_id
}

module "network" {
  source         = "./modules/network"
  resource_group = azurerm_resource_group.rg
}

module "aks" {
  source         = "./modules/aks"
  resource_group = azurerm_resource_group.rg
  seed           = random_string.seed.result
  default_node_pool = {
    vnet_subnet_id              = module.network.subnet.id
    temporary_name_for_rotation = var.k8s_default_node_pool.temporary_name_for_rotation
    name                        = var.k8s_default_node_pool.name
    min_count                   = var.k8s_default_node_pool.min_count
    max_count                   = var.k8s_default_node_pool.max_count
    max_pods                    = var.k8s_default_node_pool.max_pods
    upgrade_settings_max_surge  = var.k8s_default_node_pool.upgrade_settings_max_surge
    vm_size                     = var.k8s_default_node_pool.vm_size
  }
}

module "postgres" {
  source = "./modules/postgres"

  tenant_id                = data.azurerm_client_config.current.tenant_id
  k8s_pods_cidr            = module.aks.pod_cidr
  resource_group           = azurerm_resource_group.rg
  seed                     = random_string.seed.result
  virtual_network          = module.network.virtual_network
  flexible_server_sku_name = var.db_sku_name
  postgres_version         = var.postgres_version
}

data "azurerm_client_config" "current" {}
