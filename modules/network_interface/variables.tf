locals {
  ni_name = "${var.vmname}-nic"
}

variable "location" {
    type = string
    description = "Location of the nic same as rg"
}

variable "resource_group_name" {
    type = string
    description = "name of the resource group"
}

variable "enable_accelerated_networking" {
    type = string
    description = "enable_accelerated_networking"
    default = "false"
}

variable "subnetId" {
    type = string
    description = "Subnet ID"
}

variable "privateIpAddressAllocation" {
    type = string
    description = "Address allocation true or false"
    default = "Dynamic"
}

variable "vmname" {
    type = string
    description = "VM Name" 
}