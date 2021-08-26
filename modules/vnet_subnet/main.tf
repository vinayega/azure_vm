
resource "azurerm_virtual_network" "vnet01" {
    name = "${var.resource_group_name}-vnet01"
    location = var.location
    resource_group_name = var.resource_group_name
    address_space = var.address_space
}

resource "azurerm_subnet" "subnet01" {
    name = "${azurerm_virtual_network.vnet01.name}-subnet01"
    address_prefix = var.address_prefix
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet01.name
    depends_on = [
      azurerm_virtual_network.vnet01
    ]
}

resource "azurerm_network_security_group" "nsg01" {
    location = var.location
    name = "${azurerm_virtual_network.vnet01.name}-nsg01"
    resource_group_name = var.resource_group_name
    security_rule = [ {
        access = "Allow"
        description = "RDP Port"
        destination_address_prefix = "*"
        destination_port_range = "3389"
        direction = "Inbound"
        name = "test123"
        priority = 123
        protocol = "Tcp"
        source_address_prefix = "*"
        source_port_range = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_ranges = []
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_ranges = []
    }, 
    {
        access = "Allow"
        description = "RDP Port2"
        destination_address_prefix = "*"
        destination_port_range = "5985"
        direction = "Inbound"
        name = "test_port"
        priority = 122
        protocol = "Tcp"
        source_address_prefix = "*"
        source_port_range = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_ranges = []
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_ranges = []
    }]
  depends_on = [
    azurerm_subnet.subnet01
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg_associate" {
    network_security_group_id = azurerm_network_security_group.nsg01.id
    subnet_id = azurerm_subnet.subnet01.id

    depends_on = [
      azurerm_network_security_group.nsg01,
      azurerm_subnet.subnet01
    ]
}

