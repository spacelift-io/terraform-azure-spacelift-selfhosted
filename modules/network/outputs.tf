output "virtual_network" {
  value = azurerm_virtual_network.spacelift
}

output "subnet_id" {
  value = azurerm_subnet.spacelift.id
}