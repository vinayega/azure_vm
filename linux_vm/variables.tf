variable "location" {
  type = string
  description = "Location"
  default = "EastUS"
}

variable "rg_name" {
    type = string
    description = "Name of the Resource Group"
    default = "rg01"
}

variable "vmname" {
    type = string
    description = "Name of the VM"
    default = "linuxvm121"
}

variable "admin_username" {
    type = string
    description = "VM login Username"
    default = "testadmin1"
}

variable "admin_password" {
    type = string
    description = "Test Admin Password"
    default = "Testadmin@123" 
}

variable "size" {
    type = string
    description = "Size of the VM"
    default = "Standard_B1ms" 
}

variable "virtualmachinepublisher" {
    type = string
    description = "virtual machine publisher"
    default = "Debian" 
}

variable "virtualmachineoffer" {
    type = string
    description = "vavirtual machine offer"
    default = "debian-10"
}

variable "storageaccountname" {
    type = string
    description = "Name of the storage account"
    default = "storagescripts441"
}

variable "scripts-container" {
    type = string
    description = "Name of the container"
    default = "scripts-container"
  
}

variable "mystorageAccountKey" {
    type = string
    description = "Storage Account Key"
    default = "crgyAjX1MORtbDy63j2OvFF1/L2aApPaugNxTitsER2JvZ9+EJFjgMMVzJMQRJEfLaf6bMnEdumMuvauwYvT5A=="
  
}

variable "vmsku" {
    type = string
    description = "VM SKU"
    default = "10"
}

variable "vmversion" {
    type = string
    description = "vmversion"
    default = "latest"
}

variable "diskcaching" {
    type = string
    description = "diskcaching"
    default = "ReadWrite"
}

variable "disktype" {
    type = string
    description = "disktype"
    default = "Standard_LRS"
}

variable "disks" {
    type = list(string)
    description = "List cantains the disks"
    default = [ "ses"]
}

