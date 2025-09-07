resource "azurerm_storage_account" "backup" {
  name                     = local.storage_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = var.storage_tier
  account_replication_type = var.storage_replication # Locally Redundant Storage
  depends_on               = [azurerm_resource_group.main]
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_storage_container" "backup" {
  name                  = var.storage_container_name
  storage_account_id    = azurerm_storage_account.backup.id
  container_access_type = "private"
  depends_on = [azurerm_resource_group.main,
  azurerm_storage_account.backup]
}

resource "azurerm_storage_container" "dataprotection_container" {
  name                  = var.storage_dataprotection_name
  storage_account_id    = azurerm_storage_account.backup.id
  container_access_type = "private"
  depends_on = [azurerm_resource_group.main,
  azurerm_storage_account.backup]
}