
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
  source              = "./azure-vm-module"
  location            = "East US"
  resource_group_name = "myResourceGroup"
  vnet_name           = "myVnet"
  subnet_name         = "mySubnet"
  admin_username      = "adminuser"
  vm_count            = 2
}
