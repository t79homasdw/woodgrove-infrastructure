resource "azurerm_role_assignment" "webapp_kv_access_owner" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Owner"
  principal_id         = data.azuread_user.kv_admin.object_id
  depends_on           = [azurerm_key_vault.main]
}

resource "azurerm_role_assignment" "webapp_kv_access_owner2" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Owner"
  principal_id         = var.kv_admin2
  depends_on           = [azurerm_key_vault.main]
}

resource "azurerm_key_vault_access_policy" "webapp_kv_access_admin" {
  key_vault_id            = azurerm_key_vault.main.id
  tenant_id               = var.work_tenant_id
  object_id               = data.azuread_user.kv_admin.object_id
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
  key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  depends_on = [azurerm_key_vault.main,
    azurerm_role_assignment.webapp_kv_access_owner2
  ]
}

resource "azurerm_key_vault_access_policy" "webapp_kv_access_admin2" {
  key_vault_id            = azurerm_key_vault.main.id
  tenant_id               = var.work_tenant_id
  object_id               = var.kv_admin2
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
  key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  depends_on = [azurerm_key_vault.main,
    azurerm_role_assignment.webapp_kv_access_owner2
  ]
}

resource "azurerm_key_vault_access_policy" "allow_app_service_rp" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.work_tenant_id
  object_id    = data.azuread_service_principal.app_service_rp.object_id

  # App Service needs to read the backing PFX secret
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List"]
  depends_on = [azurerm_key_vault.main,
    azurerm_key_vault_access_policy.webapp_kv_access_admin,
    azurerm_key_vault_access_policy.webapp_kv_access_admin2
  ]
}

resource "azurerm_key_vault_access_policy" "webapp_kv_cert_access1" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.work_tenant_id
  object_id    = azurerm_windows_web_app.webapp1.identity[0].principal_id
  # App Service needs to read the backing PFX secret
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List"]

  depends_on = [
    azurerm_resource_group.main,
    azurerm_storage_account.backup,
    azurerm_key_vault.main,
    azurerm_service_plan.asp,
    azurerm_log_analytics_workspace.log,
    azurerm_application_insights.appinsights,
    azurerm_key_vault_access_policy.webapp_kv_access_admin,
    azurerm_key_vault_access_policy.webapp_kv_access_admin2,
    azurerm_windows_web_app.webapp1
  ]
}

resource "azurerm_key_vault_access_policy" "webapp_kv_cert_access2" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.work_tenant_id
  object_id    = azurerm_windows_web_app.webapp2.identity[0].principal_id
  # App Service needs to read the backing PFX secret
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List"]

  depends_on = [
    azurerm_resource_group.main,
    azurerm_storage_account.backup,
    azurerm_key_vault.main,
    azurerm_service_plan.asp,
    azurerm_log_analytics_workspace.log,
    azurerm_application_insights.appinsights,
    azurerm_key_vault_access_policy.webapp_kv_access_admin,
    azurerm_key_vault_access_policy.webapp_kv_access_admin2,
    azurerm_windows_web_app.webapp2
  ]
}

resource "azurerm_key_vault_access_policy" "webapp_kv_cert_access3" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.work_tenant_id
  object_id    = azurerm_windows_web_app.webapp3.identity[0].principal_id
  # App Service needs to read the backing PFX secret
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List"]

  depends_on = [
    azurerm_resource_group.main,
    azurerm_storage_account.backup,
    azurerm_key_vault.main,
    azurerm_service_plan.asp,
    azurerm_log_analytics_workspace.log,
    azurerm_application_insights.appinsights,
    azurerm_key_vault_access_policy.webapp_kv_access_admin,
    azurerm_key_vault_access_policy.webapp_kv_access_admin2,
    azurerm_windows_web_app.webapp3
  ]
}

resource "azurerm_key_vault_access_policy" "webapp_kv_cert_access4" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.work_tenant_id
  object_id    = azurerm_windows_web_app.webapp4.identity[0].principal_id
  # App Service needs to read the backing PFX secret
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List"]

  depends_on = [
    azurerm_resource_group.main,
    azurerm_storage_account.backup,
    azurerm_key_vault.main,
    azurerm_service_plan.asp,
    azurerm_log_analytics_workspace.log,
    azurerm_application_insights.appinsights,
    azurerm_key_vault_access_policy.webapp_kv_access_admin,
    azurerm_key_vault_access_policy.webapp_kv_access_admin2,
    azurerm_windows_web_app.webapp4
  ]
}

resource "azurerm_key_vault_access_policy" "webapp_kv_cert_access5" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.work_tenant_id
  object_id    = azurerm_windows_web_app.webapp5.identity[0].principal_id
  # App Service needs to read the backing PFX secret
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List"]

  depends_on = [
    azurerm_resource_group.main,
    azurerm_storage_account.backup,
    azurerm_key_vault.main,
    azurerm_service_plan.asp,
    azurerm_log_analytics_workspace.log,
    azurerm_application_insights.appinsights,
    azurerm_key_vault_access_policy.webapp_kv_access_admin,
    azurerm_key_vault_access_policy.webapp_kv_access_admin2,
    azurerm_windows_web_app.webapp5
  ]
}


