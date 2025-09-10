
resource "azurerm_app_service_certificate" "app_cert" {
  name                = "webapp-app-cert"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  # Use the KV secret that backs the certificate
  key_vault_secret_id = data.azurerm_key_vault_certificate.app_signing_cert.secret_id
  depends_on = [azurerm_key_vault_access_policy.allow_app_service_rp,
    azurerm_key_vault.main
  ]
}

resource "azurerm_app_service_certificate" "profile_cert" {
  name                = "webapp-profile-cert"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  # Use the KV secret that backs the certificate
  key_vault_secret_id = data.azurerm_key_vault_certificate.profile_signing_cert.secret_id
  depends_on = [azurerm_key_vault_access_policy.allow_app_service_rp,
    azurerm_key_vault.main
  ]
}

resource "azurerm_app_service_certificate" "primary_cert" {
  name                = "webapp-primary-cert"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  # Use the KV secret that backs the certificate
  key_vault_secret_id = data.azurerm_key_vault_certificate.primary_signing_cert.secret_id
  depends_on = [azurerm_key_vault_access_policy.allow_app_service_rp,
    azurerm_key_vault.main
  ]
}
