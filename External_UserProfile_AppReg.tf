############################################
# Profile App Registration - User Perms
############################################
resource "azuread_application" "profile_mod" {
  display_name     = var.appreg_userprofile
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = ["api://${local.onmicrosoft_domain}/profile-api"]
  web {
    redirect_uris = [local.appreg_redirect1]
    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }
  required_resource_access {
    resource_app_id = data.azuread_service_principal.msgraph_profile_mod.client_id

    dynamic "resource_access" {
      for_each = toset(local.existing_scopes_userprofile)
      content {
        id   = data.azuread_service_principal.msgraph_profile_mod.oauth2_permission_scope_ids[resource_access.value]
        type = "Scope"
      }
    }
    # Application permissions (roles)
    dynamic "resource_access" {
      for_each = toset(local.existing_roles_userprofile)
      content {
        id   = data.azuread_service_principal.msgraph_profile_mod.app_role_ids[resource_access.value]
        type = "Role"
      }
    }
  }
  # Expose your own API (with stable IDs)
  api {
    requested_access_token_version = 2
    mapped_claims_enabled          = true
    oauth2_permission_scope {
      admin_consent_description  = "Access UserProfile API as a user"
      admin_consent_display_name = "Access UserProfile API as a user"
      id                         = random_uuid.account_read.result
      type                       = "User"
      user_consent_description   = "Access UserProfile API as a user"
      user_consent_display_name  = "Access UserProfile API as a user"
      value                      = "Account.Read"
    }
    oauth2_permission_scope {
      admin_consent_description  = "Access and modify UserProfile API as a user"
      admin_consent_display_name = "Access and modify UserProfile API as a user"
      id                         = random_uuid.account_readwrite.result
      type                       = "User"
      user_consent_description   = "Access and modify UserProfile API as a user"
      user_consent_display_name  = "Access and modify UserProfile API as a user"
      value                      = "Account.ReadWrite"
    }
  }
  lifecycle {
    ignore_changes = [
      api,
      identifier_uris,
      required_resource_access,
      tags
    ]
  }
}


############################################
# Stable GUIDs for your API scopes
############################################
resource "random_uuid" "account_read" {}
resource "random_uuid" "account_readwrite" {}


############################################
# Attach Certificate
############################################
#resource "azuread_application_certificate" "profile_mod_cert" {
#  application_id = azuread_application.profile_mod.id
#  type           = "AsymmetricX509Cert"
#  value          = filebase64("C:/CLA_Backup/CLADemo/server.cer") # Variable defines cert
#  end_date       = "2026-07-10T15:57:18Z"                         # Adjust as needed
#  depends_on     = [azuread_application.profile_mod]
#}


############################################
# Service Principal for the app
############################################
resource "azuread_service_principal" "profile_mod_sp" {
  client_id  = azuread_application.profile_mod.client_id
  depends_on = [azuread_application.profile_mod]
}

############################################
# Allow Primary App access to exposed scopes
############################################
resource "azuread_application_pre_authorized" "authorize_profile_mod" {
  application_id       = azuread_application.profile_mod.id
  authorized_client_id = azuread_application.primary.client_id
  permission_ids = [
    random_uuid.account_read.result,
    random_uuid.account_readwrite.result
  ]
  depends_on = [
    azuread_application.profile_mod,
    azuread_application.primary
  ]
}
