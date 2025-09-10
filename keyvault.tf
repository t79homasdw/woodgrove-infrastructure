###############################################################################
# Key Vault and Secret for Storing Rotated SAS Token
###############################################################################
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


###############################################################################
# Rotation trigger (every N hours)
###############################################################################

resource "time_rotating" "rotation_trigger" {
  rotation_hours = var.rotation_interval_hours
}

###############################################################################
# Store SAS token in Key Vault
###############################################################################

resource "azurerm_key_vault_secret" "bkup_sas_token" {
  name            = var.kv_secret_name
  value           = data.azurerm_storage_account_sas.backup.sas
  key_vault_id    = azurerm_key_vault.main.id
  content_type    = "application/x-sas-token"
  expiration_date = local.sas_expiry

  tags = {
    rotated_on = timestamp()
  }

  lifecycle {
    replace_triggered_by = [time_rotating.rotation_trigger]
    ignore_changes       = [tags]
  }

  depends_on = [
    azurerm_key_vault.main,
    azurerm_key_vault_access_policy.webapp_kv_access_admin2,
    data.azurerm_storage_account_sas.backup
  ]
}

resource "null_resource" "Notify_Key_Update" {
  provisioner "local-exec" {
    command = "echo 'Secret rotated at ${time_rotating.rotation_trigger.id}'"
  }
  depends_on = [azurerm_key_vault_secret.bkup_sas_token]
}
