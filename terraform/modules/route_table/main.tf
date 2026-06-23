resource "azurerm_route_table" "spoke" {
  name                          = "rt-${var.spoke_name}-${var.env}"
  location                      = var.location
  resource_group_name           = var.rg_name
  bgp_route_propagation_enabled = false

  tags = {
    environment = var.env
    project     = var.project
    managed_by  = "terraform"
  }
}

# Force all traffic through Azure Firewall in the hub
resource "azurerm_route" "to_firewall" {
  name                   = "route-all-to-firewall"
  resource_group_name    = var.rg_name
  route_table_name       = azurerm_route_table.spoke.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.fw_private_ip
}

# Associate route table with the spoke subnet
resource "azurerm_subnet_route_table_association" "spoke" {
  subnet_id      = var.subnet_id
  route_table_id = azurerm_route_table.spoke.id
}