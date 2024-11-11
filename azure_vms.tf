module "azure_vms" {
  source                = "./azure-vm-module"
  location              = "West US"
  resource_group_name   = "Regroup_2fmmcKxqMNP"
  vnet_name             = "application-vnet"
  subnet_name           = "default"
  vnet_address_space    = "10.0.0.0/16"
  subnet_address_prefix = "10.0.0.0/24"
  admin_username        = "adminuser"
  vm_count              = 1
}
