# Central Log Analytics workspace — all logs flow here
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.project}-${var.env}"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = var.env
    project     = var.project
    managed_by  = "terraform"
  }
}

# Send Azure Firewall diagnostic logs to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "firewall" {
  name                       = "diag-firewall-${var.env}"
  target_resource_id         = var.firewall_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "AzureFirewallApplicationRule"
  }

  enabled_log {
    category = "AzureFirewallNetworkRule"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Send prod VM metrics to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "vm_prod" {
  name                       = "diag-vm-prod-${var.env}"
  target_resource_id         = var.vm_prod_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Send dev VM metrics to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "vm_dev" {
  name                       = "diag-vm-dev-${var.env}"
  target_resource_id         = var.vm_dev_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Alert rule — fires if firewall drops more than 10 packets per minute
resource "azurerm_monitor_metric_alert" "firewall_dropped_packets" {
  name                = "alert-fw-dropped-packets-${var.env}"
  resource_group_name = var.rg_name
  scopes              = [var.firewall_id]
  description         = "Alert when firewall drops more than 10 packets per minute"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Network/azureFirewalls"
    metric_name      = "FirewallHealth"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 90
  }

  tags = {
    environment = var.env
    project     = var.project
    managed_by  = "terraform"
  }
}

# Action group — where alerts get sent
resource "azurerm_monitor_action_group" "main" {
  name                = "ag-${var.project}-${var.env}"
  resource_group_name = var.rg_name
  short_name          = "ag-alerts"

  tags = {
    environment = var.env
    project     = var.project
    managed_by  = "terraform"
  }
}