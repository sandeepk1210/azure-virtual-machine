# Windows Virtual Machines
resource "azurerm_windows_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "vms-${count.index + 1}"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = azurerm_key_vault_secret.admin_password.value
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
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

