module "vnet_subnet_nsg" {
    source = "../modules/vnet_subnet"
    resource_group_name = var.rg_name
    location = var.location
    depends_on = [
      module.rg_create
    ]
}

module "rg_create" {
    source = "../modules/resourcegroup"
    name = var.rg_name
    location = var.location
}

module "nic_creation" {
    source = "../modules/network_interface"
    vmname = var.vmname
    location = var.location
    resource_group_name = var.rg_name
    subnetId = module.vnet_subnet_nsg.subnet_id
    depends_on = [
      module.vnet_subnet_nsg
    ]
}

resource "azurerm_windows_virtual_machine" "winndowsvm" {
    computer_name = var.vmname
    admin_username = var.admin_username
    admin_password = var.admin_password
    name = var.vmname
    location = var.location
    resource_group_name = var.rg_name
    size = var.size
    //priority = "Spot"
    //eviction_policy = "Deallocate"
    network_interface_ids = [
      module.nic_creation.id 
    ]
source_image_reference {
    publisher = var.virtualmachinepublisher
    offer = var.virtualmachineoffer
    sku = var.vmsku
    version = var.vmversion
}

winrm_listener {
  protocol = "Http"
}

provision_vm_agent = true

os_disk {
    caching = var.diskcaching
    storage_account_type = var.disktype

}

}

/*

resource "azurerm_managed_disk" "disk2" {
    count = length(var.disks)
    location = var.location
    name = "${var.disks[count.index]}-diskname"
    resource_group_name = var.rg_name
    create_option = "Empty"
    storage_account_type = var.disktype
    disk_size_gb = "10"
    disk_encryption_set_id = data.azurerm_disk_encryption_set.diskencryptionset.id

    depends_on = [
      azurerm_windows_virtual_machine.winndowsvm
    ]
}

resource "azurerm_virtual_machine_data_disk_attachment" "diskattach" {
    count = length(var.disks)
    managed_disk_id = azurerm_managed_disk.disk2[count.index].id
    caching = var.diskcaching
    lun = count.index
    virtual_machine_id = azurerm_windows_virtual_machine.winndowsvm.id
}


/*
data "azurerm_disk_encryption_set" "diskencryptionset" {
    name = "de_manageddisk"
    resource_group_name = "practice_rg"
}

/* data "template_file" "windows_post_deploy" {
    template = file("../scripts/windows_post_deploy.ps1")  
}
 */
//"commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString[System.Convert]::FromBase64String('${base64encode(data.template_file.windows_post_deploy.rendered)}'))

 /*
  resource "azurerm_virtual_machine_extension" "custom_script_extension" {
    
    depends_on = [
      azurerm_virtual_machine_data_disk_attachment.diskattach,
      azurerm_storage_blob.scriptsblob
    ]
    name = "custom_script_post_deploy"
    publisher = "Microsoft.Compute"
    type = "CustomScriptExtension"
    virtual_machine_id = azurerm_windows_virtual_machine.winndowsvm.id
    type_handler_version = "1.9"

    settings = <<SETTINGS
        {
            "fileUris": ["https://${var.storageaccountname}.blob.core.windows.net/${var.scripts-container}/windows_post_deploy_v5.ps1"]
        }
    SETTINGS

     protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File windows_post_deploy_v5.ps1",
      "storageAccountName": "${azurerm_storage_account.storageaccount.name}",
      "storageAccountKey": "${azurerm_storage_account.storageaccount.primary_access_key}"
    }
    PROTECTED_SETTINGS
    
    // jsonencode({
    //    #"commandToExecute": "powershell.exe -executionpolicy bypass -command ${data.template_file.windows_post_deploy.rendered}"
    //    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${data.template_file.windows_post_deploy.rendered }')) | Out-File -filepath postBuild.ps1\" && powershell -ExecutionPolicy Unrestricted -File postBuild.ps1"
    //})  
  
 } 

locals {
  stacc_key = azurerm_storage_account.storageaccount.primary_access_key
}

/*
resource "azurerm_storage_account" "storageaccount" {
    account_tier = "Standard"
    account_replication_type = "LRS"
    location = var.location
    resource_group_name = module.rg_create.name
    name = var.storageaccountname  
    account_kind = "StorageV2"
}

resource "azurerm_storage_container" "storagecontainer" {
    name = var.scripts-container
    storage_account_name = azurerm_storage_account.storageaccount.name
}

resource "azurerm_storage_blob" "scriptsblob" {
    name = "windows_post_deploy_v5.ps1"
    type = "Block"
    storage_container_name = azurerm_storage_container.storagecontainer.name
    source = "../scripts/windows_post_deploy.ps1"
    storage_account_name = azurerm_storage_account.storageaccount.name
}


*/

/* resource "null_resource" "copy1" {
    
    depends_on = [
      azurerm_virtual_machine_data_disk_attachment.diskattach
    ]
    
    provisioner "file" {
        source = "../scripts/windows_post_deploy.ps1"
        destination = "c:/windows_post_deploy.ps1"

        connection {
          type = "winrm"
          user = var.admin_username
          password = var.admin_password
          host = module.nic_creation.publicIp
          port = "5985"
          https = false
        }
    }
  
} */