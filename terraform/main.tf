resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project}-${var.env}"
  location = var.location

  tags = {
    environment = var.env
    project     = var.project
    managed_by  = "terraform"
  }
}

module "hub_vnet" {
  source              = "./modules/hub_vnet"
  rg_name             = azurerm_resource_group.main.name
  location            = var.location
  env                 = var.env
  project             = var.project
}

module "spoke_prod" {
  source               = "./modules/spoke_vnet"
  rg_name              = azurerm_resource_group.main.name
  location             = var.location
  env                  = var.env
  project              = var.project
  spoke_name           = "prod"
  spoke_vnet_cidr      = "10.1.0.0/16"
  workload_subnet_cidr = "10.1.1.0/24"
}

module "spoke_dev" {
  source               = "./modules/spoke_vnet"
  rg_name              = azurerm_resource_group.main.name
  location             = var.location
  env                  = var.env
  project              = var.project
  spoke_name           = "dev"
  spoke_vnet_cidr      = "10.2.0.0/16"
  workload_subnet_cidr = "10.2.1.0/24"
}

module "peering_prod" {
  source              = "./modules/peering"
  rg_name             = azurerm_resource_group.main.name
  hub_vnet_name       = module.hub_vnet.hub_vnet_name
  hub_vnet_id         = module.hub_vnet.hub_vnet_id
  spoke_vnet_name     = module.spoke_prod.spoke_vnet_name
  spoke_vnet_id       = module.spoke_prod.spoke_vnet_id
  spoke_name          = "prod"
}

module "peering_dev" {
  source              = "./modules/peering"
  rg_name             = azurerm_resource_group.main.name
  hub_vnet_name       = module.hub_vnet.hub_vnet_name
  hub_vnet_id         = module.hub_vnet.hub_vnet_id
  spoke_vnet_name     = module.spoke_dev.spoke_vnet_name
  spoke_vnet_id       = module.spoke_dev.spoke_vnet_id
  spoke_name          = "dev"
}

module "vm_prod" {
  source              = "./modules/vm_test"
  rg_name             = azurerm_resource_group.main.name
  location            = var.location
  env                 = var.env
  project             = var.project
  spoke_name          = "prod"
  subnet_id           = module.spoke_prod.workload_subnet_id
  admin_password      = var.vm_admin_password
}

module "vm_dev" {
  source              = "./modules/vm_test"
  rg_name             = azurerm_resource_group.main.name
  location            = var.location
  env                 = var.env
  project             = var.project
  spoke_name          = "dev"
  subnet_id           = module.spoke_dev.workload_subnet_id
  admin_password      = var.vm_admin_password
}

module "nsg_prod" {
  source              = "./modules/nsg"
  rg_name             = azurerm_resource_group.main.name
  location            = var.location
  env                 = var.env
  project             = var.project
  spoke_name          = "prod"
  subnet_id           = module.spoke_prod.workload_subnet_id
}

module "nsg_dev" {
  source              = "./modules/nsg"
  rg_name             = azurerm_resource_group.main.name
  location            = var.location
  env                 = var.env
  project             = var.project
  spoke_name          = "dev"
  subnet_id           = module.spoke_dev.workload_subnet_id
}

module "route_table_prod" {
  source                = "./modules/route_table"
  rg_name               = azurerm_resource_group.main.name
  location              = var.location
  env                   = var.env
  project               = var.project
  spoke_name            = "prod"
  subnet_id             = module.spoke_prod.workload_subnet_id
  fw_private_ip         = module.fw.fw_private_ip
}

module "route_table_dev" {
  source                = "./modules/route_table"
  rg_name               = azurerm_resource_group.main.name
  location              = var.location
  env                   = var.env
  project               = var.project
  spoke_name            = "dev"
  subnet_id             = module.spoke_dev.workload_subnet_id
  fw_private_ip         = module.fw.fw_private_ip
}

module "fw" {
  source                = "./modules/firewall"
  rg_name               = azurerm_resource_group.main.name
  location              = var.location
  env                   = var.env
  project               = var.project
  fw_subnet_id          = module.hub_vnet.firewall_subnet_id
}

module "monitoring" {
  source      = "./modules/monitoring"
  rg_name     = azurerm_resource_group.main.name
  location    = var.location
  env         = var.env
  project     = var.project
  firewall_id = module.fw.fw_id
  vm_prod_id  = module.vm_prod.vm_id
  vm_dev_id   = module.vm_dev.vm_id
}

