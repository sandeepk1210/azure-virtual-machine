output "vm_public_ips" {
  description = "The public IP addresses of the virtual machines"
  value       = azurerm_public_ip.public_ip[*].ip_address
}

output "key_vault_name" {
  description = "Key Vault Name"
  value       = azurerm_key_vault.kv.name
}

output "admin_username" {
  value = azurerm_windows_virtual_machine.vm[*].admin_username
}

output "admin_password" {
  value     = azurerm_key_vault_secret.admin_password
  sensitive = true
}
