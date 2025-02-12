output "pod_cidr" {
  value = azurerm_kubernetes_cluster.self-hosted.network_profile[0].pod_cidr
}

output "node_principal_id" {
  value = azurerm_kubernetes_cluster.self-hosted.kubelet_identity[0].object_id
}