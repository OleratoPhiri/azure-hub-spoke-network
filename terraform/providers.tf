terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.78.0"
    }
  }

 backend "azurerm" {
  resource_group_name  = "rg-tfstate"
  storage_account_name = "tfstateop2506"
  container_name       = "tfstate"
  key                  = "hub-spoke-network.tfstate"
}
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}