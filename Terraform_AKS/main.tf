provider "azurerm" {
  features {}
  subscription_id = "f1bfd146-7097-4a68-b3c6-24c404a1355a"
}

resource "azurerm_resource_group" "rg" {
  name     = "pitstop-rg"
  location = "westeurope"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "pitstop-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  count               = 2
  name                = "pitstop-subnet-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = [cidrsubnet("10.0.0.0/16", 8, count.index)]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "pitstop-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "pitstop-aks"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_B2s" 
    vnet_subnet_id = azurerm_subnet.subnet[0].id
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  
}