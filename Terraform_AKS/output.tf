output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "subnet_ids" {
  value = azurerm_subnet.subnet[*].id
}