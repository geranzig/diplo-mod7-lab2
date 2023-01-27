terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
    subscription_id=var.aks_service_principal_suscription_id
    client_id = var.aks_service_principal_app_id
    client_secret =var.aks_service_principal_client_secret
    tenant_id = var.aks_service_principal_tenant_id 
  features {}
}