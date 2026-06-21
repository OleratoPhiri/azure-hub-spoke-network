variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "South Africa North"
}

variable "environment" {
  description = "Environment tag applied to all resources"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name tag applied to all resources"
  type        = string
  default     = "hub-spoke-network"
}

variable "vm_admin_password" {
  description = "Admin password for test VMs"
  type        = string
  sensitive   = true
}