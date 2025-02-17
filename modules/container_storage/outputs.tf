output "large_queue_messages_container" {
  value = "spacelift-large-queue-messages"
}

output "metadata_container" {
  value = "spacelift-metadata"
}

output "modules_container" {
  value = "spacelift-modules"
}

output "policy_inputs_container" {
  value = "spacelift-policy-inputs"
}

output "run_logs_container" {
  value = "spacelift-run-logs"
}

output "states_container" {
  value = "spacelift-states"
}

output "uploads_container" {
  value = "spacelift-uploads"
}

output "user_uploaded_workspaces_container" {
  value = "spacelift-user-uploaded-workspaces"
}

output "workspaces_container" {
  value = "spacelift-workspaces"
}

output "deliveries_container" {
  value = "spacelift-deliveries"
}

output "storage_account_url" {
  value = trimsuffix(azurerm_storage_account.spacelift_storage_account.primary_blob_endpoint, "/")
}