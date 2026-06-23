resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-spoke-${var.spoke_name}-${var.env}"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = [var.spoke_vnet_cidr]

  tags = {
    environment = var.env
    project     = var.project
    role        = "spoke-${var.spoke_name}"
    managed_by  = "terraform"
  }
}

resource "azurerm_subnet" "workload" {
  name                 = "snet-workload-${var.spoke_name}-${var.env}"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.workload_subnet_cidr]
}