variable "rg_name" {
  description = "Resource group to deploy the spoke VNet into"
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

variable "spoke_name" {
  description = "Name identifier for this spoke e.g. prod or dev"
  type        = string
}

variable "spoke_vnet_cidr" {
  description = "CIDR block for the spoke VNet"
  type        = string
}

variable "workload_subnet_cidr" {
  description = "CIDR block for the workload subnet inside the spoke"
  type        = string
}