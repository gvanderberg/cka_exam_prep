module "rg" {
  source = "./modules/rg"

  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = var.tags
}

module "lb" {
  source = "./modules/lb"

  resource_group_name     = module.rg.resource_group_name
  resource_group_location = module.rg.resource_group_location
  tags                    = var.tags
}

module "nsg" {
  source = "./modules/nsg"

  resource_group_name     = module.rg.resource_group_name
  resource_group_location = module.rg.resource_group_location
  tags                    = var.tags
}

module "vnet" {
  source = "./modules/vnet"

  resource_group_name     = module.rg.resource_group_name
  resource_group_location = module.rg.resource_group_location
  tags                    = var.tags
}

module "master" {
  source = "./modules/vm"

  admin_password          = var.admin_password
  backend_address_pool_id = module.lb.backend_address_pool_id
  computer_name           = "azvpznmaster0"
  resource_group_name     = module.rg.resource_group_name
  resource_group_location = module.rg.resource_group_location
  subnet_id               = module.vnet.subnet_id
  tags                    = var.tags
  virtual_machine_count   = 2
  virtual_machine_name    = "azvm-dev-zn-master0"
  virtual_machine_size    = "Standard_B1ms"
}

module "worker" {
  source = "./modules/vm"

  admin_password          = var.admin_password
  backend_address_pool_id = ""
  computer_name           = "azvpznworker0"
  resource_group_name     = module.rg.resource_group_name
  resource_group_location = module.rg.resource_group_location
  subnet_id               = module.vnet.subnet_id
  tags                    = var.tags
  virtual_machine_count   = 2
  virtual_machine_name    = "azvm-dev-zn-worker0"
  virtual_machine_size    = "Standard_B1ms"
}
