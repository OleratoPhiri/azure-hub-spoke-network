variable "rg_name" {
  description = "Resource group for the route table"
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
  description = "Spoke this route table belongs to"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to associate the route table with"
  type        = string
}

variable "fw_private_ip" {
  description = "Private IP of the Azure Firewall in the hub — updated in Phase 4"
  type        = string
  default     = "10.0.1.4"
}