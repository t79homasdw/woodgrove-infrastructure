resource "azurerm_service_plan" "asp" {
  name                = var.asp_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = var.asp_os_type
  sku_name            = var.asp_sku_name

  depends_on = [azurerm_resource_group.main]
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
