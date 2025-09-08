#-------------------------------------------------
# Keyvault Creation - Default is "true"
#-------------------------------------------------
resource "azurerm_key_vault" "main" {
  name                      = lower("kv-${var.kv_name}")
  location                  = local.location
  resource_group_name       = local.resource_group_name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = var.kv_sku_pricing_tier
  enabled_for_deployment    = var.kv_enabled_for_deployment
  enable_rbac_authorization = var.kv_enable_rbac_authorization
  purge_protection_enabled  = var.kv_enable_purge_protection
  depends_on                = [azurerm_resource_group.main]
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_role_assignment" "webapp_kv_access_admin" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_user.kv_admin.object_id
  depends_on           = [azurerm_key_vault.main]
}

resource "azurerm_role_assignment" "webapp_kv_access_admin2" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = "11111111-1111-1111-1111-111111111111" # Replace with actual Object ID of the application registration not client ID
  depends_on           = [azurerm_key_vault.main]
}

resource "azurerm_role_assignment" "webapp_kv_access_owner" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Owner"
  principal_id         = data.azuread_user.kv_admin.object_id
  depends_on           = [azurerm_key_vault.main]
}

resource "azurerm_role_assignment" "webapp_kv_access_owner2" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Owner"
  principal_id         = "11111111-1111-1111-1111-111111111111" # Replace with actual Object ID of the application registration not client ID
  depends_on           = [azurerm_key_vault.main]
}

module "sas_token_rotation" {
  source                  = "./modules/secret_rotation"
  key_vault_id            = azurerm_key_vault.main.id
  secret_name             = var.kv_secret_name
  rotation_interval_hours = 720 # Rotate every 30 days
  depends_on = [
    azurerm_key_vault.main,
    azurerm_role_assignment.webapp_kv_access_admin2
  ]
}

