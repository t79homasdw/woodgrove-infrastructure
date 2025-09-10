
#############################################
# Store App Registration Secrets in Key Vault
#############################################

resource "azurerm_key_vault_secret" "ciam_primary_secret" {
  name         = var.appreg_primarysec
  value        = azuread_application_password.primary_secret.value
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azuread_application_password.primary_secret,
    azurerm_key_vault.main
  ]
}

resource "azurerm_key_vault_secret" "ciam_profile_secret" {
  name         = var.appreg_userprofilesec
  value        = azuread_application_password.profile_mod_secret.value
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azuread_application_password.profile_mod_secret,
    azurerm_key_vault.main
  ]
}

resource "azurerm_key_vault_secret" "ciam_app_secret" {
  name         = var.appreg_appsec
  value        = azuread_application_password.app_perms_secret.value
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azuread_application_password.app_perms_secret,
    azurerm_key_vault.main
  ]
}
