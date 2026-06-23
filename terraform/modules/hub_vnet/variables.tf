variable "rg_name" {
  description = "Resource group to deploy the hub VNet into"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "env" {
  description = "Environment tag"
  type        = string
}

variable "project" {
  description = "Project tag"
  type        = string
}

variable "hub_vnet_cidr" {
  description = "CIDR block for the hub VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "firewall_subnet_cidr" {
  description = "CIDR for AzureFirewallSubnet — name is fixed by Azure"
  type        = string
  default     = "10.0.1.0/26"
}

variable "gateway_subnet_cidr" {
  description = "CIDR for GatewaySubnet — name is fixed by Azure"
  type        = string
  default     = "10.0.2.0/27"
}

variable "management_subnet_cidr" {
  description = "CIDR for the management/bastion subnet"
  type        = string
  default     = "10.0.3.0/24"
}