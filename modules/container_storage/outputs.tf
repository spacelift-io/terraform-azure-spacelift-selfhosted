output "large_queue_messages_container" {
  value = azurerm_storage_container.spacelift-container["spacelift-large-queue-messages"].name
}

output "metadata_container" {
  value = azurerm_storage_container.spacelift-container["spacelift-metadata"].name
}

output "modules_container" {
  value = azurerm_storage_container.spacelift-container["spacelift-modules"].name
}

output "policy_inputs_container" {
  value = azurerm_storage_container.spacelift-container["spacelift-policy-inputs"].name
}

output "run_logs_container" {
  value = azurerm_storage_container.spacelift-container["spacelift-run-logs"].name
}

output "states_container" {
  value = azurerm_storage_container.spacelift-container["spacelift-states"].name
}

output "uploads_container" {
  value = azurerm_storage_container.spacelift-container["spacelift-uploads"].name
}

output "user_uploaded_workspaces_container" {
  value = azurerm_storage_container.spacelift-container["spacelift-user-uploaded-workspaces"].name
}

output "workspaces_container" {
  value = azurerm_storage_container.spacelift-container["spacelift-workspaces"].name
}

output "deliveries_container" {
  value = azurerm_storage_container.spacelift-container["spacelift-deliveries"].name
}

output "storage_account_url" {
  value = trimsuffix(azurerm_storage_account.spacelift_storage_account.primary_blob_endpoint, "/")
}

output "storage_account_name" {
  value = azurerm_storage_account.spacelift_storage_account.name
}