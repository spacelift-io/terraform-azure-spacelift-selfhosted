output "pod_cidr" {
  value = azurerm_kubernetes_cluster.self-hosted.network_profile[0].pod_cidr
}