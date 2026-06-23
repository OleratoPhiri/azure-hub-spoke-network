variable "rg_name" {
  description = "Resource group for the NSG"
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
  description = "Spoke this NSG belongs to e.g. prod or dev"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to associate the NSG with"
  type        = string
}