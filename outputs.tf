output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.grupo5_terraform_vm.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.grupo5_ssh.private_key_pem
  sensitive = true
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.grupo5_kubernetes.kube_config[0].client_certificate
  sensitive = true
}

output "client_key" {
  value     = azurerm_kubernetes_cluster.grupo5_kubernetes.kube_config[0].client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.grupo5_kubernetes.kube_config[0].cluster_ca_certificate
  sensitive = true
}

output "cluster_password" {
  value     = azurerm_kubernetes_cluster.grupo5_kubernetes.kube_config[0].password
  sensitive = true
}

output "cluster_username" {
  value     = azurerm_kubernetes_cluster.grupo5_kubernetes.kube_config[0].username
  sensitive = true
}

output "host" {
  value     = azurerm_kubernetes_cluster.grupo5_kubernetes.kube_config[0].host
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.grupo5_kubernetes.kube_config_raw
  sensitive = true
}
