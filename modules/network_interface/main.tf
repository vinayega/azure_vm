resource "azurerm_network_interface" "networkinterface" {
    name = local.ni_name
    location = var.location
    resource_group_name = var.resource_group_name
    enable_accelerated_networking = var.enable_accelerated_networking

    ip_configuration {
      name = "${local.ni_name}-ipconfig"
      subnet_id = var.subnetId
      private_ip_address_allocation = var.privateIpAddressAllocation
      public_ip_address_id = azurerm_public_ip.publicip.id
    }
    depends_on = [
      azurerm_public_ip.publicip
    ]
}

resource "azurerm_public_ip" "publicip" {
    location = var.location
    allocation_method = "Static"
    name = "${local.ni_name}-publicip"
    resource_group_name = var.resource_group_name
}