############################################
# App Permissions - Appliation Registration
############################################
resource "azuread_application" "app_perms" {
  display_name = var.appreg_appperms
  web {
    redirect_uris = [local.appreg_redirect1]
    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }
  identifier_uris = ["api://${local.onmicrosoft_domain}/payment-api"]
  required_resource_access {
    resource_app_id = data.azuread_service_principal.msgraph_app_perms.client_id

    # Delegate permissions (scopes)
    dynamic "resource_access" {
      for_each = toset(local.existing_roles_app)
      content {
        id   = data.azuread_service_principal.msgraph_app_perms.app_role_ids[resource_access.value]
        type = "Role"
      }
    }
    # Application permissions (roles)
    dynamic "resource_access" {
      for_each = toset(local.existing_roles_app)
      content {
        id   = data.azuread_service_principal.msgraph_app_perms.app_role_ids[resource_access.value]
        type = "Role"
      }
    }
  }
  # Expose your own API (with stable IDs)
  api {
    requested_access_token_version = 2
    mapped_claims_enabled          = true
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
resource "random_uuid" "payment_read" {}

resource "azuread_application_permission_scope" "payment_read" {
  application_id             = azuread_application.app_perms.id
  scope_id                   = random_uuid.payment_read.result
  value                      = "Payment.Read"
  type                       = "User"
  admin_consent_display_name = "Access and modify UserProfile API as a user"
  admin_consent_description  = "Access and modify UserProfile API as a user"
  user_consent_display_name  = "Access and modify UserProfile API as a user"
  user_consent_description   = "Access and modify UserProfile API as a user"
  depends_on                 = [random_uuid.payment_read]
}

resource "random_uuid" "payment_readwrite" {}

resource "azuread_application_permission_scope" "payment_readwrite" {
  application_id             = azuread_application.app_perms.id
  scope_id                   = random_uuid.payment_readwrite.result
  value                      = "Payment.ReadWrite"
  type                       = "User"
  admin_consent_display_name = "Access and modify UserProfile API as a user"
  admin_consent_description  = "Access and modify UserProfile API as a user"
  user_consent_display_name  = "Access and modify UserProfile API as a user"
  user_consent_description   = "Access and modify UserProfile API as a user"
  depends_on                 = [random_uuid.payment_readwrite]
}

resource "random_uuid" "user_mfa" {}

resource "azuread_application_permission_scope" "user_mfa" {
  application_id             = azuread_application.app_perms.id
  scope_id                   = random_uuid.user_mfa.result
  value                      = "User.MFA"
  type                       = "User"
  admin_consent_display_name = "Access and modify UserProfile API as a user"
  admin_consent_description  = "Access and modify UserProfile API as a user"
  user_consent_display_name  = "Access and modify UserProfile API as a user"
  user_consent_description   = "Access and modify UserProfile API as a user"
  depends_on                 = [random_uuid.user_mfa]
}



############################################
# Attach Certificate
############################################
# This terraform code is not yet supported for CIAM tenants
#resource "azuread_application_certificate" "app_perms_cert" {
#  application_id = azuread_application.app_perms.id
#  type           = "AsymmetricX509Cert"
#  value          = filebase64("C:/CLA_Backup/CLADemo/server.cer") # Variable defines cert
#  end_date       = "2026-07-10T15:57:18Z"                         # Adjust as needed
#  depends_on     = [azuread_application.profile_mod]
#}


###########################################
# Service Principal for the app
############################################
resource "azuread_service_principal" "app_perms" {
  client_id  = azuread_application.app_perms.client_id
  depends_on = [azuread_application.profile_mod]
}

############################################
# Allow Primary App to access exposed scopes
############################################
resource "azuread_application_pre_authorized" "authorize_app_perms" {
  application_id       = azuread_application.app_perms.id
  authorized_client_id = azuread_application.primary.client_id
  permission_ids = [
    random_uuid.user_mfa.result,
    random_uuid.payment_readwrite.result,
    random_uuid.payment_read.result
  ]
  depends_on = [
    azuread_application_permission_scope.payment_read,
    azuread_application_permission_scope.payment_readwrite,
    azuread_application_permission_scope.user_mfa,
    azuread_application.app_perms,
    azuread_application.primary
  ]
}

#############################################
# Client Secret for the app
#############################################
resource "azuread_application_password" "app_perms_secret" {
  application_id = "/applications/${azuread_application.app_perms.object_id}"
  display_name   = var.appreg_appsec
  end_date       = local.sas_expiry
  depends_on     = [azuread_application.app_perms]
}
