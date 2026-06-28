variable "rg_name" {
  description = "Resource group for monitoring resources"
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

variable "firewall_id" {
  description = "ID of the Azure Firewall to monitor"
  type        = string
}

variable "vm_prod_id" {
  description = "ID of the prod spoke VM"
  type        = string
}

variable "vm_dev_id" {
  description = "ID of the dev spoke VM"
  type        = string
}