resource "azurerm_kubernetes_cluster" "grupo5_kubernetes" {
  location            = azurerm_resource_group.rg.location
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.k8s_version 
  tags                = {
    Environment = "Development"
  }

  default_node_pool {
    name       = "default"
    vm_size    = "Standard_B2ms"
    #node_count = var.agent_count
    enable_auto_scaling = true
    max_count = 3
    min_count = 1
    max_pods = 80
  }


  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure" 
  }

 # role_based_access_control_enabled = true
#
  role_based_access_control{
    enabled = true
    azure_active_directory {
        server_app_id     =  var.ad_server_id
        client_app_id     =  var.ad_client_id
        server_app_secret =  var.ad_secret_id
        tenant_id         =  var.aks_service_principal_tenant_id
    }
  }
  service_principal {
    client_id     = var.aks_service_principal_app_id
    client_secret = var.aks_service_principal_client_secret
  }
}

resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_kubernetes_cluster.grupo5_kubernetes]
  filename     = "./kubeconfig"
  content      = azurerm_kubernetes_cluster.grupo5_kubernetes.kube_config_raw
}

##Agregar nodosyes
#Descomentar una vez que se haya creado el cluster para que se agrgue el nuevo nodo
#resource "azurerm_kubernetes_cluster_node_pool" "example" {
#  name                  = "internal"
#  kubernetes_cluster_id = azurerm_kubernetes_cluster.grupo5_kubernetes.id
#  vm_size               = "Standard_B2ms"
#  node_count            = 1
#  node_labels =  { "node-type" : "Adicional" }
#  max_pods = 80
#  tags = {
#    Environment = "Development"
#  }
#}