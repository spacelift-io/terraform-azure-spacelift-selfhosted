resource "azurerm_storage_account" "spacelift_storage_account" {
  name                     = "spacelift${var.seed}"
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  blob_properties {
    versioning_enabled = true
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["PUT", "POST"]
      allowed_origins    = ["https://${var.app_domain}"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }
  }
}

locals {
  containers = [
    "spacelift-large-queue-messages",
    "spacelift-metadata",
    "spacelift-modules",
    "spacelift-policy-inputs",
    "spacelift-run-logs",
    "spacelift-states",
    "spacelift-uploads",
    "spacelift-user-uploaded-workspaces",
    "spacelift-workspaces",
    "spacelift-deliveries",
  ]
}

resource "azurerm_storage_container" "spacelift-container" {
  for_each = toset(local.containers)
  name     = each.value

  storage_account_name  = azurerm_storage_account.spacelift_storage_account.name
  container_access_type = "private"

}

resource "azurerm_storage_management_policy" "large_queue_messages_policy" {
  storage_account_id = azurerm_storage_account.spacelift_storage_account.id

  rule {
    name    = "DeleteAfter1Day"
    enabled = true

    filters {
      blob_types = ["blockBlob"]
      prefix_match = [
        "spacelift-uploads",
        "spacelift-user-uploaded-workspaces",
        "spacelift-deliveries",
      ]
    }

    actions {
      base_blob {
        delete_after_days_since_creation_greater_than = 1
      }
    }
  }

  rule {
    name    = "DeleteAfter2Days"
    enabled = true

    filters {
      blob_types = ["blockBlob"]
      prefix_match = [
        "spacelift-large-queue-messages",
        "spacelift-metadata",
        "spacelift-states"
      ]
    }

    actions {
      base_blob {
        delete_after_days_since_creation_greater_than = 2
      }
    }
  }

  rule {
    name    = "DeleteAfter7Days"
    enabled = true

    filters {
      blob_types = ["blockBlob"]
      prefix_match = [
        "spacelift-policy-inputs",
        "spacelift-workspaces",
      ]
    }

    actions {
      base_blob {
        delete_after_days_since_creation_greater_than = 7
      }
    }
  }

  rule {
    name    = "DeleteAfter60Days"
    enabled = true

    filters {
      blob_types = ["blockBlob"]
      prefix_match = [
        "spacelift-run-logs",
      ]
    }

    actions {
      base_blob {
        delete_after_days_since_creation_greater_than = 60
      }
    }
  }
}

resource "azurerm_role_assignment" "kube_access_object_storage" {
  scope                            = azurerm_storage_account.spacelift_storage_account.id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = var.kubernetes_object_id
  skip_service_principal_aad_check = true
}
