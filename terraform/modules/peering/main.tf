# Peering from hub to spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-${var.spoke_name}"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = var.spoke_vnet_id

  # Hub allows gateway transit so spokes can use hub gateway later
  allow_gateway_transit     = true
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}

# Peering from spoke to hub — peering must be created in both directions
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-${var.spoke_name}-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.spoke_vnet_name
  remote_virtual_network_id = var.hub_vnet_id

  # Spoke uses hub gateway and allows forwarded traffic from firewall
  use_remote_gateways          = false
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}