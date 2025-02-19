output "virtual_network" {
  value = azurerm_virtual_network.spacelift
}

output "subnet" {
  value = azurerm_subnet.spacelift
}

output "public_ip_address" {
  value = azurerm_public_ip.ipv4.ip_address
}