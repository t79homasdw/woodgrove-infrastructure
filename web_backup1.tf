
resource "azurerm_resource_group_template_deployment" "webapp_backup1" {
  name                = "webapp-backup-deployment1"
  resource_group_name = azurerm_resource_group.main.name
  deployment_mode     = "Incremental"

  template_content = jsonencode({
    "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion" : "1.0.0.0",
    "parameters" : {
      "sasToken" : {
        "type" : "SecureString"
      },
      "siteName" : {
        "type" : "String"
      },
      "storageAccountName" : {
        "type" : "String"
      },
      "containerName" : {
        "type" : "String"
      }
    },
    "resources" : [
      {
        "type" : "Microsoft.Web/sites/config",
        "apiVersion" : "2022-03-01",
        "name" : "[concat(parameters('siteName'), '/backup')]",
        "location" : "[resourceGroup().location]",
        "properties" : {
          "enabled" : true,
          "storageAccountUrl" : "[concat('https://', parameters('storageAccountName'), '.blob.core.windows.net/', parameters('containerName'), '?', parameters('sasToken'))]",
          "backupSchedule" : {
            "frequencyInterval" : 1,
            "frequencyUnit" : "Day",
            "keepAtLeastOneBackup" : true,
            "retentionPeriodInDays" : 30,
            "startTime" : "2025-01-01T00:00:00Z"
          }
        }
      }
    ]
  })
  parameters_content = jsonencode({
    siteName = {
      value = azurerm_windows_web_app.webapp1.name
    }
    storageAccountName = {
      value = azurerm_storage_account.backup.name
    }
    containerName = {
      value = azurerm_storage_container.backup.name
    }
    sasToken = {
      value = data.azurerm_key_vault_secret.bkup_sas_token.value
    }
  })

  depends_on = [
    azurerm_windows_web_app.webapp1,
    azurerm_storage_account.backup,
    azurerm_storage_container.backup,
    data.azurerm_key_vault_secret.bkup_sas_token
  ]
}