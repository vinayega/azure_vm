output "id" {
    value = azurerm_network_interface.networkinterface.id
}

output "name" {
    value = azurerm_network_interface.networkinterface.name
}

output "publicIp" {
    value = azurerm_public_ip.publicip.ip_address
  
}