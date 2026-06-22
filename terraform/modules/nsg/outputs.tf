output "nsg_id" {
  description = "ID of the NSG"
  value       = azurerm_network_security_group.spoke.id
}

output "nsg_name" {
  description = "Name of the NSG"
  value       = azurerm_network_security_group.spoke.name
}