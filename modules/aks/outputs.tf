output "pod_cidr" {
  value = azurerm_kubernetes_cluster.self-hosted.network_profile[0].pod_cidr
}

output "node_principal_id" {
  value = azurerm_kubernetes_cluster.self-hosted.kubelet_identity[0].object_id
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.self-hosted.name
}

output "public_ip_address" {
  value = azurerm_public_ip.ipv4.ip_address
}