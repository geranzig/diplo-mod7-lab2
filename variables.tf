variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "k8s_version"{
  default =  "1.23.8"
}
variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "agent_count" {
  default = 2
}

variable "add_agent_count"{
  default = 2
}

variable "aks_service_principal_app_id" {
  default = ""
}

variable "aks_service_principal_client_secret" {
  default = ""
}
variable "aks_service_principal_suscription_id" {
  default = ""
}

variable "aks_service_principal_tenant_id" {
  default = ""
}

variable "ad_secret_id" {
  default = ""
}

variable "ad_client_id" {
  default = ""
}

variable "ad_server_id" {
  default = ""
}



variable "cluster_name" {
  default = "grupo5_aks"
}

variable "dns_prefix" {
  default = "aks1"
}

variable "ssh_public_key" {
  default = "id_rsa"
}