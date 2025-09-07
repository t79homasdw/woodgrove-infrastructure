resource "azurerm_log_analytics_workspace" "log" {
  name                = var.la_workspace_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.la_workspace_sku
  retention_in_days   = var.la_workspace_retention
  depends_on          = [azurerm_resource_group.main]
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
