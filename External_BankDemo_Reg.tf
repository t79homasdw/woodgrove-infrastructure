############################################
# Bank App Registration
############################################
resource "azuread_application" "bank_demo" {
  display_name = var.appreg_bankdemo

  web {
    redirect_uris = [local.appreg_redirect2, local.appreg_redirect1]
    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }
  api {
    requested_access_token_version = 2
    mapped_claims_enabled          = true
  }
  required_resource_access {
    resource_app_id = data.azuread_service_principal.msgraph_primary.client_id
    # Delegated scopes
    dynamic "resource_access" {
      for_each = toset(local.existing_scopes_primary)
      content {
        id   = data.azuread_service_principal.msgraph_primary.oauth2_permission_scope_ids[resource_access.value]
        type = "Scope"
      }
    }
  }
  lifecycle {
    ignore_changes = [api,
      identifier_uris,
    tags]
  }
}

############################################
# Attach Certificate
############################################
#resource "azuread_application_certificate" "primary_cert" {
#  application_id = azuread_application.primary.id
#  type           = "AsymmetricX509Cert"
#  value          = filebase64("C:/CLA_Backup/CLADemo/server.cer") # Variable defines cert
#  end_date       = "2026-07-10T15:57:18Z"                         # Adjust as needed
#  depends_on     = [azuread_application.primary]
#}


############################################
# Service Principal for the app
############################################
resource "azuread_service_principal" "bank_sp" {
  client_id = azuread_application.bank_demo.client_id
  feature_tags {
    enterprise            = true
    custom_single_sign_on = true
  }
  preferred_single_sign_on_mode = "saml"

  saml_single_sign_on {
    # Set the Entity ID (Identifier)
    relay_state = "https://${azurerm_windows_web_app.webapp5.default_hostname}/"
  }

  depends_on = [azuread_application.bank_demo,
    azurerm_windows_web_app.webapp5
  ]
}


resource "azuread_service_principal_token_signing_certificate" "saml_cert" {
  service_principal_id = azuread_service_principal.bank_sp.id
  display_name         = "CN=${var.appreg_bankdemo}-SAML"
  depends_on           = [azuread_service_principal.bank_sp]
}
