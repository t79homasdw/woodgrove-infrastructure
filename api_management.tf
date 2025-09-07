resource "azurerm_api_management" "apim" {
  name                = var.apim_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  publisher_name      = var.apim_publisher
  publisher_email     = var.apim_publisher_email
  sku_name            = var.apim_sku


  # NEW: System-assigned identity for APIM (required for the MI policy)
  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_resource_group.main,
    azurerm_windows_web_app.webapp1,
    azurerm_windows_web_app.webapp2,
    azurerm_windows_web_app.webapp3,
    azurerm_windows_web_app.webapp4
  ]

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_api_management_api" "api" {
  name                = var.apim_api_name
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.apim.name
  revision            = var.apim_api_revision
  display_name        = var.apim_display_name
  path                = var.apim_path
  protocols           = ["https"]

  import {
    content_format = "openapi+json-link"
    content_value  = "https://petstore3.swagger.io/api/v3/openapi.json"
  }
  depends_on = [
    azurerm_api_management.apim
  ]
}
