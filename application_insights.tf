resource "azurerm_application_insights" "appinsights" {
  name                = var.appinsights_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = var.appinsights_apptype
  workspace_id        = azurerm_log_analytics_workspace.log.id

  depends_on = [
    azurerm_resource_group.main,
    azurerm_log_analytics_workspace.log,
  ]
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
