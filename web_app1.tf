resource "azurerm_windows_web_app" "webapp1" {
  name                    = var.webapp1_name
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  service_plan_id         = azurerm_service_plan.asp.id
  https_only              = var.web_https_only              # Enforce HTTPS
  client_affinity_enabled = var.web_client_affinity_enabled # Session affinity ON (ARR)

  identity {
    type = "SystemAssigned"
  }

  # NEW: App Service Authentication/Authorization (Auth v2)
  auth_settings_v2 {
    auth_enabled           = var.web_auth_enabled
    require_authentication = var.web_require_authentication
    require_https          = var.web_require_https
    default_provider       = var.web_default_provider
    unauthenticated_action = var.web_unauthenticated_action # Better for APIs behind APIM

    #{
    #  (Optional but recommended) limit accepted audiences
    #    allowed_audiences = [azuread_application.primaryapp.client_id]
    #} 

    login {
      token_store_enabled = var.web_token_store_enabled
    }

    active_directory_v2 {
      # App Registration configured for your API (the protected resource)
      client_id = var.web_client_id

      # Issuer for your tenant (v2.0 endpoint)
      tenant_auth_endpoint = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/v2.0"
    }
  }

  site_config {
    always_on               = var.site_always_on
    ftps_state              = var.site_ftps_state
    minimum_tls_version     = var.site_min_tls_version # Force TLS 1.2 Minimum
    scm_minimum_tls_version = var.site_scm_min_tls_version
    use_32_bit_worker       = var.site_use_32_bit_worker_process # 32-bit platform

    # Windows Web App stack config in azurerm v4.x
    application_stack {
      dotnet_version = var.dotnet_version # e.g., "v8.0" (see note below)
    }
  }

  # Session affinity proxy is OFF by default in Azure; no explicit setting in Terraform  

  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.appinsights.connection_string

    # Optional legacy (Instrumentation Key is deprecated but still works if you want it)
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.appinsights.instrumentation_key

    "AzureWebJobsStorage"        = azurerm_storage_account.backup.primary_connection_string
    "LOG_ANALYTICS_WORKSPACE_ID" = azurerm_log_analytics_workspace.log.id

    # Requested Env Variables
    "ASPNETCORE_ENVIRONMENT"    = var.ASPNETCORE_ENVIRONMENT
    "WEBSITE_LOAD_CERTIFICATES" = var.WEBSITE_LOAD_CERTIFICATES
    "BACKUP_SAS_TOKEN"          = "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.bkup_sas_token.id})"
  }

  depends_on = [
    azurerm_resource_group.main,
    azurerm_storage_account.backup,
    azurerm_key_vault.main,
    azurerm_service_plan.asp,
    azurerm_log_analytics_workspace.log,
    azurerm_application_insights.appinsights
  ]
  lifecycle {
    ignore_changes = [
      app_settings,
      backup,
      tags
    ]
  }
}

resource "azurerm_role_assignment" "storage_access1" {
  scope                = azurerm_storage_account.backup.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_windows_web_app.webapp1.identity[0].principal_id

  depends_on = [
    azurerm_resource_group.main,
    azurerm_storage_account.backup,
    azurerm_key_vault.main,
    azurerm_service_plan.asp,
    azurerm_log_analytics_workspace.log,
    azurerm_application_insights.appinsights,
    azurerm_windows_web_app.webapp5
  ]
}

resource "azurerm_role_assignment" "webapp_kv_access1" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_windows_web_app.webapp1.identity[0].principal_id

  depends_on = [
    azurerm_resource_group.main,
    azurerm_storage_account.backup,
    azurerm_key_vault.main,
    azurerm_service_plan.asp,
    azurerm_log_analytics_workspace.log,
    azurerm_application_insights.appinsights,
    azurerm_windows_web_app.webapp4
  ]
}
