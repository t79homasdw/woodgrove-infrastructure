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
  user_principal_name = "user@<tenant-name>.onmicrosoft.com" # Change to your admin user
  provider            = azuread.workforce
}

data "azurerm_key_vault_secret" "bkup_sas_token" {
  name         = var.kv_secret_name
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [
    azurerm_key_vault.main,
    azurerm_key_vault_secret.bkup_sas_token,
    data.azurerm_storage_account_sas.backup,
    azurerm_key_vault_access_policy.webapp_kv_access_admin
  ]
}

data "azurerm_api_management" "apim" {
  name                = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.main.name
  depends_on          = [azurerm_api_management.apim]
}


data "azuread_service_principal" "deployment_app" {
  client_id = var.web_client_id
  provider  = azuread.workforce
}

data "azuread_service_principal" "app_service_rp" {
  client_id = "abfa0a7c-a6b6-4736-8310-5855508787cd"  # Do Not change - Microsoft Azure App Service
  provider  = azuread.workforce
}

data "azurerm_key_vault_certificate" "primary_signing_cert" {
  name         = azurerm_key_vault_certificate.primary_signing_cert.name
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [azurerm_key_vault.main,
  azurerm_key_vault_certificate.primary_signing_cert]
}

data "azurerm_key_vault_certificate" "profile_signing_cert" {
  name         = azurerm_key_vault_certificate.profile_signing_cert.name
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [azurerm_key_vault.main,
  azurerm_key_vault_certificate.profile_signing_cert]
}


data "azurerm_key_vault_certificate" "app_signing_cert" {
  name         = azurerm_key_vault_certificate.app_signing_cert.name
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [azurerm_key_vault.main,
  azurerm_key_vault_certificate.app_signing_cert]
}


data "azurerm_key_vault_secret" "primary_signing_cert" {
  name         = azurerm_key_vault_certificate.primary_signing_cert.name
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [azurerm_key_vault.main,
  azurerm_key_vault_certificate.primary_signing_cert]
}

data "azurerm_key_vault_secret" "profile_signing_cert" {
  name         = azurerm_key_vault_certificate.profile_signing_cert.name
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [azurerm_key_vault.main,
  azurerm_key_vault_certificate.profile_signing_cert]
}

data "azurerm_key_vault_secret" "app_signing_cert" {
  name         = azurerm_key_vault_certificate.app_signing_cert.name
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [azurerm_key_vault.main,
  azurerm_key_vault_certificate.app_signing_cert]
}

data "azurerm_key_vault_secret" "ciam_primary_secret" {
  name         = azurerm_key_vault_secret.ciam_primary_secret.name
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [azurerm_key_vault.main,
    azurerm_key_vault_secret.ciam_primary_secret,
  azurerm_key_vault_certificate.primary_signing_cert]
}

data "azurerm_key_vault_secret" "ciam_profile_secret" {
  name         = azurerm_key_vault_secret.ciam_profile_secret.name
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [azurerm_key_vault.main,
  azurerm_key_vault_secret.ciam_profile_secret]
}

data "azurerm_key_vault_secret" "ciam_app_secret" {
  name         = azurerm_key_vault_secret.ciam_app_secret.name
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [azurerm_key_vault.main,
  azurerm_key_vault_secret.ciam_app_secret]
}