azure-vm-module/
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md

# Azure Virtual Machine Module

This Terraform module creates one or more Azure Windows Virtual Machines with the following features:

- Uses an existing resource group.
- Stores the VM admin password in an Azure Key Vault secret.
- Provisions each VM with IIS and creates a `Default.html` file.

## Usage

```hcl
module "azure_vms" {
  source                = "./azure-vm-module"
  location              = "West US"
  resource_group_name   = "Regroup_7czMK_Ny6owa"
  vnet_name             = "application-vnet"
  subnet_name           = "default"
  vnet_address_space    = "10.0.0.0/16"
  subnet_address_prefix = "10.0.0.0/24"
  admin_username        = "adminuser"
  vm_count              = 2
}
```
