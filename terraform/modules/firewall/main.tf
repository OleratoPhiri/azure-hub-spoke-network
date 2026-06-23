# Firewall requires a public IP
resource "azurerm_public_ip" "fw_pip"{
    name                = "pip-firewall-${var.env}"
    location            = var.location
    resource_group_name = var.rg_name
    allocation_method   = "Static"
    sku                 = "Standard"

    tags = {
        environment     = var.env
        project         = var.project
        managed_by      ="terraform"
    }
}

resource "azurerm_firewall" "hub"{
    name                = "afw-hub-${var.env}"
    location            = var.location
    resource_group_name = var.rg_name
    sku_name            = "AZFW_VNet"
    sku_tier            = "Standard"

    ip_configuration {
        name                    = "fw-ipconfig"
        subnet_id               = var.fw_subnet_id
        public_ip_address_id    = azurerm_public_ip.fw_pip.id
    }

    tags = {
        environment = var.env
        project     = var.project
        managed_by  = "terraform"
    }
}

# Rules for spoke-to-spoke traffic 
resource "azurerm_firewall_network_rule_collection" "spoke_to_spoke" {
    name                    = "nrc-spoke-to-spoke"
    azure_firewall_name     = azurerm_firewall.hub.name
    resource_group_name     = var.rg_name
    priority                = 100
    action                  = "Allow"

    rule {
        name                    = "allow-ssh"
        protocols               = ["TCP"]
        source_addresses        = ["10.1.0.0/16", "10.2.0.0/16"]
        destination_addresses   = ["10.1.0.0/16", "10.2.0.0/16"]
        destination_ports       = ["22"]
    }

    rule {
        name                    = "allow-icmp"
        protocols               = ["ICMP"]
        source_addresses        = ["10.1.0.0/16", "10.2.0.0/16"]
        destination_addresses   = ["10.1.0.0/16", "10.2.0.0/16"]
        destination_ports       = ["*"]
    }
}

# Outbound internet access for system updates
resource "azurerm_firewall_application_rule_collection" "internet_outbound" {
    name                    = "arc-internet-outbound"
    azure_firewall_name     = azurerm_firewall.hub.name
    resource_group_name     = var.rg_name
    priority                = 200
    action                  = "Allow"

    rule {
        name                = "ubuntu-updates"
        source_addresses    = ["10.1.0.0/16", "10.2.0.0/16"]
        target_fqdns        = [
            "*.ubuntu.com",
            "*.canonical.com",
            "security.ubuntu.com",
            "archive.ubuntu.com"
        ]

        protocol {
            port = "80"
            type = "Http"
        }

        protocol {
            port = "443"
            type = "Https"
        }
    }
}