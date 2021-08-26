variable "location" {
    type = string
    description = "Name of the vnet"
}

variable "address_space" {
    type = list(string)
    description = "Address Space"
    default = ["10.0.0.0/24"]  
}

variable "address_prefix" {
    type = string
    description = "Subnet address prefix"
    default = "10.0.0.0/27"
}

variable "resource_group_name" {
    type = string
    description = "Resource Group Name"
  
}