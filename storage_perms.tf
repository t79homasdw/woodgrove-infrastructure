###################################################################################
# Assign Storage Blob Data Contributor role to Web Apps for Storage Account access
###################################################################################

resource "azurerm_role_assignment" "storage_access1" {
  scope                = azurerm_storage_account.backup.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_windows_web_app.webapp1.identity[0].principal_id

  depends_on = [
    azurerm_resource_group.main,
    azurerm_storage_account.backup,
    azurerm_key_vault.main,
    azurerm_service_plan.asp,
    azurerm_log_analytics_workspace.log,
    azurerm_application_insights.appinsights,
    azurerm_windows_web_app.webapp1
  ]
}
resource "azurerm_role_assignment" "storage_access2" {
  scope                = azurerm_storage_account.backup.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_windows_web_app.webapp2.identity[0].principal_id

  depends_on = [
    azurerm_resource_group.main,
    azurerm_storage_account.backup,
    azurerm_key_vault.main,
    azurerm_service_plan.asp,
    azurerm_log_analytics_workspace.log,
    azurerm_application_insights.appinsights,
    azurerm_windows_web_app.webapp2
  ]
}
resource "azurerm_role_assignment" "storage_access3" {
  scope                = azurerm_storage_account.backup.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_windows_web_app.webapp3.identity[0].principal_id

  depends_on = [
    azurerm_resource_group.main,
    azurerm_storage_account.backup,
    azurerm_key_vault.main,
    azurerm_service_plan.asp,
    azurerm_log_analytics_workspace.log,
    azurerm_application_insights.appinsights,
    azurerm_windows_web_app.webapp3
  ]
}
resource "azurerm_role_assignment" "storage_access4" {
  scope                = azurerm_storage_account.backup.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_windows_web_app.webapp4.identity[0].principal_id

  depends_on = [
    azurerm_resource_group.main,
    azurerm_storage_account.backup,
    azurerm_key_vault.main,
    azurerm_service_plan.asp,
    azurerm_log_analytics_workspace.log,
    azurerm_application_insights.appinsights,
    azurerm_windows_web_app.webapp4
  ]
}
resource "azurerm_role_assignment" "storage_access5" {
  scope                = azurerm_storage_account.backup.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_windows_web_app.webapp5.identity[0].principal_id

  depends_on = [
    azurerm_resource_group.main,
    azurerm_storage_account.backup,
    azurerm_key_vault.main,
    azurerm_service_plan.asp,
    azurerm_log_analytics_workspace.log,
    azurerm_application_insights.appinsights,
    azurerm_windows_web_app.webapp5
  ]
}