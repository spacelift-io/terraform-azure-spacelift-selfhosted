output "public_registry_name" {
  value = azurerm_container_registry.self_hosted_public.name
}

output "private_registry_name" {
  value = azurerm_container_registry.self_hosted.name
}

output "private_registry_url" {
  value = "${azurerm_container_registry.self_hosted.name}.azurecr.io"
}

output "public_registry_url" {
  value = "${azurerm_container_registry.self_hosted_public.name}.azurecr.io"
}