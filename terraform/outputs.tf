output "resource_group_name" {
  description = "Name of the main resource group"
  value       = azurerm_resource_group.main.name
}

output "hub_vnet_id" {
  description = "ID of the hub VNet"
  value       = module.hub_vnet.hub_vnet_id
}

output "hub_vnet_name" {
  description = "Name of the hub VNet"
  value       = module.hub_vnet.hub_vnet_name
}