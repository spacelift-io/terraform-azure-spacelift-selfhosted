resource "azurerm_key_vault" "spacelift" {
  location                   = var.resource_group.location
  name                       = "spacelift${var.seed}"
  resource_group_name        = var.resource_group.name
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  tenant_id                  = var.client_config.tenant_id
  enable_rbac_authorization  = true
}

resource "azurerm_key_vault_secret" "postgres-password" {
  key_vault_id = azurerm_key_vault.spacelift.id
  name         = "postgres-password"
  value        = var.postgres_password

  depends_on = [azurerm_role_assignment.key-vault-admin-current-client]
}

resource "azurerm_role_assignment" "key-vault-access-admin-current-client" {
  scope                = azurerm_key_vault.spacelift.id
  role_definition_name = "Key Vault Data Access Administrator"
  principal_id         = var.client_config.object_id
}

resource "azurerm_role_assignment" "key-vault-admin-current-client" {
  scope                = azurerm_key_vault.spacelift.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.client_config.object_id
}
