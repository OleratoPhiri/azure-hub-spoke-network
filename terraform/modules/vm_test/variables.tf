variable "rg_name" {
  description = "Resource group for the test VM"
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
  description = "Spoke this VM belongs to e.g. prod or dev"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to place the VM in"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}