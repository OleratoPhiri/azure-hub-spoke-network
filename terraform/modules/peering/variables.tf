variable "resource_group_name" {
  description = "Resource group containing both VNets"
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub VNet"
  type        = string
}

variable "hub_vnet_id" {
  description = "ID of the hub VNet"
  type        = string
}

variable "spoke_vnet_name" {
  description = "Name of the spoke VNet"
  type        = string
}

variable "spoke_vnet_id" {
  description = "ID of the spoke VNet"
  type        = string
}

variable "spoke_name" {
  description = "Short name for this spoke e.g. prod or dev"
  type        = string
}