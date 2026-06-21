output "vm_private_ip" {
  description = "Private IP of the test VM"
  value       = azurerm_network_interface.vm.private_ip_address
}

output "vm_public_ip" {
  description = "Public IP of the test VM"
  value       = azurerm_public_ip.vm.ip_address
}