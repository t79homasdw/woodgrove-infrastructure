# Generate SAS Token for Backup Access
data "azurerm_storage_account_sas" "backup" {
  connection_string = azurerm_storage_account.backup.primary_connection_string
  https_only        = true
  start             = local.sas_start
  expiry            = local.sas_expiry # 1 year
  services {
    blob  = true
    file  = false
    queue = false
    table = false
  }
  resource_types {
    service   = true
    container = true
    object    = true
  }
  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false
  }
  depends_on = [
    azurerm_key_vault.main,
    azurerm_storage_account.backup,
    azurerm_storage_container.backup,
    time_rotating.rotation_trigger
  ]
}