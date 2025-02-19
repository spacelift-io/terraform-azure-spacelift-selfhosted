output "postgres_password" {
  sensitive = true
  value     = random_password.db-root-password.result
}

output "postgres_address" {
  value = "${azurerm_postgresql_flexible_server.postgres.name}.postgres.database.azure.com"
}

output "postgres_name" {
  value = azurerm_postgresql_flexible_server.postgres.name
}