output "fw_private_ip" {
    type        = string
    description = "Private IP of the Azure Firewall for route tables"
    value       = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}

output "fw_public_ip" {
    type        = string
    description = "Public IP for VPN peers"
    value       = azurerm_public_ip.fw_pip.ip_address
}


output "fw_name" {
    type        = string
    description = "Hub firewall name"
    value       = azurerm_firewall.hub.name
}

output "fw_id" {
  description = "ID of the Azure Firewall"
  value       = azurerm_firewall.hub.id
}
