# Windows Virtual Machines
resource "azurerm_windows_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "vms-${count.index + 1}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = azurerm_key_vault_secret.admin_password[count.index].value
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  os_disk {
    caching                = "ReadWrite"
    storage_account_type   = "Standard_LRS"
    disk_encryption_set_id = azurerm_disk_encryption_set.des.id
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_key_vault.kv,
    azurerm_key_vault_access_policy.des_policy
  ]
}

# Custom Script Extension to install IIS and create Default.html
resource "azurerm_virtual_machine_extension" "iis_extension" {
  count                = var.vm_count
  name                 = "iis-extension-${count.index + 1}"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = jsonencode({
    commandToExecute = "powershell -command \"Install-WindowsFeature -name Web-Server; New-Item -Path 'C:\\inetpub\\wwwroot\\Default.html' -ItemType File -Force; Add-Content -Path 'C:\\inetpub\\wwwroot\\Default.html' -Value '<html><body><h1>Hello from VM ${(count.index + 1)}</h1></body></html>'\""
  })
}

# Disk Encryption Set using Key Vault Key
# A Disk Encryption Set provides centralized control over encryption for managed disks in Azure. 
# By associating the DES with a Key Vault key, we can use customer-managed keys (CMK) 
# to encrypt and decrypt data on disks, ensuring that you manage the encryption keys
# rather than relying solely on Azure’s platform-managed keys.
resource "azurerm_disk_encryption_set" "des" {
  name                = "disk-encryption-set-${random_string.unique.result}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  key_vault_key_id    = azurerm_key_vault_key.encryption_key.id
  identity {
    type = "SystemAssigned"
  }
}
