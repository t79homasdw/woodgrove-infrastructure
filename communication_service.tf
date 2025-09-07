resource "azurerm_communication_service" "com-service" {
  name                = var.com_service_name
  resource_group_name = azurerm_resource_group.main.name
  data_location       = var.com_data_loc
  depends_on          = [azurerm_resource_group.main]
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_email_communication_service" "email" {
  name                = var.email_service_name
  resource_group_name = azurerm_resource_group.main.name
  data_location       = var.com_data_loc

  lifecycle {
    ignore_changes = [tags]
  }
  depends_on = [
    azurerm_communication_service.com-service
  ]
}

resource "azurerm_email_communication_service_domain" "azure_managed" {
  name              = "AzureManagedDomain"
  email_service_id  = azurerm_email_communication_service.email.id
  domain_management = "AzureManaged" # Azure provides and manages the sending domain
  # Optional: enable engagement tracking
  # user_engagement_tracking_enabled = true
  depends_on = [
    azurerm_communication_service.com-service,
    azurerm_email_communication_service.email
  ]
}


resource "azurerm_communication_service_email_domain_association" "assoc" {
  communication_service_id = azurerm_communication_service.com-service.id
  email_service_domain_id  = azurerm_email_communication_service_domain.azure_managed.id
  depends_on = [
    azurerm_communication_service.com-service,
    azurerm_email_communication_service.email,
    azurerm_email_communication_service_domain.azure_managed
  ]
}
