data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "rg_integrator" {
    name = "${var.prefix}-rg"
    location = var.location
}

resource "azurerm_virtual_network" "vnet_integrator" {
  name = "${var.prefix}-vnet"
  resource_group_name = azurerm_resource_group.rg_integrator.name
  location = var.location
  address_space = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "aks_subnet_integrator" {
  name = "${var.prefix}-aks-subnet"
  resource_group_name = azurerm_resource_group.rg_integrator.name
  virtual_network_name = azurerm_virtual_network.vnet_integrator.name
  address_prefixes = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "acr_subnet_integrator" {
  name = "${var.prefix}-acr-subnet"
  resource_group_name = azurerm_resource_group.rg_integrator.name
  virtual_network_name = azurerm_virtual_network.vnet_integrator.name
  address_prefixes = ["10.2.0.0/16"]
}

resource "azurerm_network_security_group" "nsg_integrator" {
  name = "${var.prefix}-nsg"
  resource_group_name = azurerm_resource_group.rg_integrator.name
  location = var.location
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_aks" {
  subnet_id = azurerm_subnet.aks_subnet_integrator.id
  network_security_group_id = azurerm_network_security_group.nsg_integrator.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_acr" {
  subnet_id = azurerm_subnet.acr_subnet_integrator.id
  network_security_group_id = azurerm_network_security_group.nsg_integrator.id
}

resource "azurerm_container_registry" "acr_integrator" {
  name = "${var.prefix}acr"
  resource_group_name = azurerm_resource_group.rg_integrator.name
  location = var.location
  sku = "Standard"
  admin_enabled = false
}

resource "azurerm_key_vault" "vault_integrator" {
  name = "${var.prefix}-vault"
  resource_group_name = azurerm_resource_group.rg_integrator.name
  location = var.location
  sku_name = "standard"
  tenant_id = data.azuread_client_config.current.tenant_id
}

resource "azurerm_kubernetes_cluster" "aks_integrator" {
    name = "${var.prefix}-aks-cluster"
    resource_group_name = azurerm_resource_group.rg_integrator.name
    location = var.location
    role_based_access_control_enabled = true
    dns_prefix = var.prefix

  default_node_pool {
    name = "nodepool"
    vm_size = "Standard_B2s"
    node_count = 1
  }
  
  identity {
    type = "SystemAssigned"
  }
}
