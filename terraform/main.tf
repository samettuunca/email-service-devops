terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "email" {
  name     = "email-service-rg"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "email" {
  name                = "email-service-aks"
  location            = azurerm_resource_group.email.location
  resource_group_name = azurerm_resource_group.email.name
  dns_prefix          = "emailservice"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2s_v3"
  }

  identity {
    type = "SystemAssigned"
  }
}