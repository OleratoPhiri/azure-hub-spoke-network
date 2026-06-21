resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.location

  tags = {
    environment = var.environment
    project     = var.project
    managed_by  = "terraform"
  }
}

module "hub_vnet" {
  source              = "./modules/hub_vnet"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  environment         = var.environment
  project             = var.project
}

module "spoke_prod" {
  source               = "./modules/spoke_vnet"
  resource_group_name  = azurerm_resource_group.main.name
  location             = var.location
  environment          = var.environment
  project              = var.project
  spoke_name           = "prod"
  spoke_vnet_cidr      = "10.1.0.0/16"
  workload_subnet_cidr = "10.1.1.0/24"
}

module "spoke_dev" {
  source               = "./modules/spoke_vnet"
  resource_group_name  = azurerm_resource_group.main.name
  location             = var.location
  environment          = var.environment
  project              = var.project
  spoke_name           = "dev"
  spoke_vnet_cidr      = "10.2.0.0/16"
  workload_subnet_cidr = "10.2.1.0/24"
}

module "peering_prod" {
  source              = "./modules/peering"
  resource_group_name = azurerm_resource_group.main.name
  hub_vnet_name       = module.hub_vnet.hub_vnet_name
  hub_vnet_id         = module.hub_vnet.hub_vnet_id
  spoke_vnet_name     = module.spoke_prod.spoke_vnet_name
  spoke_vnet_id       = module.spoke_prod.spoke_vnet_id
  spoke_name          = "prod"
}

module "peering_dev" {
  source              = "./modules/peering"
  resource_group_name = azurerm_resource_group.main.name
  hub_vnet_name       = module.hub_vnet.hub_vnet_name
  hub_vnet_id         = module.hub_vnet.hub_vnet_id
  spoke_vnet_name     = module.spoke_dev.spoke_vnet_name
  spoke_vnet_id       = module.spoke_dev.spoke_vnet_id
  spoke_name          = "dev"
}

module "vm_prod" {
  source              = "./modules/vm_test"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  environment         = var.environment
  project             = var.project
  spoke_name          = "prod"
  subnet_id           = module.spoke_prod.workload_subnet_id
  admin_password      = var.vm_admin_password
}

module "vm_dev" {
  source              = "./modules/vm_test"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  environment         = var.environment
  project             = var.project
  spoke_name          = "dev"
  subnet_id           = module.spoke_dev.workload_subnet_id
  admin_password      = var.vm_admin_password
}