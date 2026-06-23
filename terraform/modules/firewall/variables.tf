variable "rg_name"{
    type        = string
    description = "Firewall RG"
}

variable "location"{
    type        = string
    description = "Az region"
}

variable "env" {
    type        = string
    description = "target deployment"
}

variable "project" {
    type        = string
    description = "project identifier"
}

variable "fw_subnet_id"{
    type    = string
    description = "ID of AzureFirewallSubnet in the hub VNet"
}

