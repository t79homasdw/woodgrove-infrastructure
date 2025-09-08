data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}
data "azuread_domains" "current" {}

data "azuread_application_published_app_ids" "well_known_primary" {}

data "azuread_service_principal" "msgraph_primary" {
  client_id = data.azuread_application_published_app_ids.well_known_primary.result["MicrosoftGraph"]
}

data "azuread_application_published_app_ids" "well_known_app_perms" {}
data "azuread_service_principal" "msgraph_app_perms" {
  client_id = data.azuread_application_published_app_ids.well_known_app_perms.result["MicrosoftGraph"]
}

data "azuread_application_published_app_ids" "well_known_profile_mod" {}
data "azuread_service_principal" "msgraph_profile_mod" {
  client_id = data.azuread_application_published_app_ids.well_known_profile_mod.result["MicrosoftGraph"]
}

data "azuread_user" "kv_admin" {
  user_principal_name = "user#EXT#@<tenant-name>.onmicrosoft.com"
  provider            = azuread.workforce
}

data "azurerm_key_vault_secret" "bkup_sas_token" {
  name         = var.kv_secret_name
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [
    azurerm_key_vault.main,
    data.azurerm_storage_account_sas.backup,
    azurerm_role_assignment.webapp_kv_access_admin
  ]
}

data "azurerm_api_management" "apim" {
  name                = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.main.name
  depends_on          = [azurerm_api_management.apim]
}

#data "azurerm_api_management_api" "api" {
#  name                = var.apim_api_name
#  api_management_name = data.azurerm_api_management.apim.name
#  resource_group_name = azurerm_resource_group.main.name
#  revision            = var.apim_api_revision # e.g., "1"
#  depends_on = [
#    azurerm_api_management_api.api
#  ]
#}
