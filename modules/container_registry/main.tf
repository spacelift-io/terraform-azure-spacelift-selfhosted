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

resource "azurerm_role_assignment" "kube_pull_acr" {
  scope                            = azurerm_container_registry.self_hosted.id
  role_definition_name             = "AcrPull"
  principal_id                     = var.node_principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_container_registry_task" "acr_purge_task_backend_image" {
  count                 = var.number_of_images_to_retain > 0 ? 1 : 0
  name                  = "acr-purge-backend-image"
  container_registry_id = azurerm_container_registry.self_hosted.id
  platform {
    os = "Linux"
  }

  encoded_step {
    task_content = base64encode(<<-EOF
version: v1.1.0
steps:
  - cmd: acr purge --filter 'spacelift-backend:.*' --ago 1d --keep ${var.number_of_images_to_retain}
EOF
    )
    context_path = "/dev/null"
  }

  identity {
    type = "SystemAssigned"
  }

  timer_trigger {
    name     = "daily-purge-schedule"
    schedule = "0 0 * * *"
  }
}

resource "azurerm_container_registry_task" "acr_purge_task_launcher_image" {
  count                 = var.number_of_images_to_retain > 0 ? 1 : 0
  name                  = "acr-purge-launcher-image"
  container_registry_id = azurerm_container_registry.self_hosted_public.id
  platform {
    os = "Linux"
  }

  encoded_step {
    task_content = base64encode(<<-EOF
version: v1.1.0
steps:
  - cmd: acr purge --filter 'spacelift-launcher:.*' --ago 1d --keep ${var.number_of_images_to_retain}
EOF
    )
    context_path = "/dev/null"
  }

  identity {
    type = "SystemAssigned"
  }

  timer_trigger {
    name     = "daily-purge-schedule"
    schedule = "0 0 * * *"
  }
}