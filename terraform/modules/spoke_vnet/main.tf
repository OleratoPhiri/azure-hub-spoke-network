resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-spoke-${var.spoke_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.spoke_vnet_cidr]

  tags = {
    environment = var.environment
    project     = var.project
    role        = "spoke-${var.spoke_name}"
    managed_by  = "terraform"
  }
}

resource "azurerm_subnet" "workload" {
  name                 = "snet-workload-${var.spoke_name}-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.workload_subnet_cidr]
}