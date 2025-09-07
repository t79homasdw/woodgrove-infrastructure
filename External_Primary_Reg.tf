############################################
# Primary App Registration - Parent
############################################
resource "azuread_application" "primary" {
  display_name = var.appreg_primaryapp

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "Allows users to process orders"
    display_name         = "Orders.Manager"
    enabled              = true
    id                   = random_uuid.Orders_Manager.result
    value                = "Orders.Manager"
  }

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "Allows users to manage products."
    display_name         = "Products.Contributor"
    enabled              = true
    id                   = random_uuid.Products_Contributor.result
    value                = "Products.Contributor"
  }

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "Allows users to manage products."
    display_name         = "ExclusiveDemosSecurityGroup"
    enabled              = true
    id                   = random_uuid.ExclusiveDemos_SecurityGroup.result
    value                = "ExclusiveDemosSecurityGroup"
  }

  web {
    redirect_uris = [local.appreg_redirect, local.appreg_redirect1]
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
    # Application permissions (roles)
    dynamic "resource_access" {
      for_each = toset(local.existing_roles_primary)
      content {
        id   = data.azuread_service_principal.msgraph_primary.app_role_ids[resource_access.value]
        type = "Role"
      }
    }
  }
  required_resource_access {
    resource_app_id = azuread_application.profile_mod.client_id
    resource_access {
      id   = random_uuid.account_read.result
      type = "Scope"
    }
    resource_access {
      id   = random_uuid.account_readwrite.result
      type = "Scope"
    }
  }
  required_resource_access {
    resource_app_id = azuread_application.app_perms.client_id
    resource_access {
      id   = random_uuid.payment_read.result
      type = "Scope"
    }
    resource_access {
      id   = random_uuid.payment_readwrite.result
      type = "Scope"
    }
    resource_access {
      id   = random_uuid.user_mfa.result
      type = "Scope"
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
  depends_on = [
    azuread_application_permission_scope.payment_read,
    azuread_application_permission_scope.payment_readwrite,
    azuread_application_permission_scope.user_mfa,
    random_uuid.account_read,
    random_uuid.account_readwrite
  ]
}

############################################
# Stable GUIDs for your API scopes
############################################
resource "random_uuid" "Orders_Manager" {}
resource "random_uuid" "Products_Contributor" {}
resource "random_uuid" "ExclusiveDemos_SecurityGroup" {}

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
resource "azuread_service_principal" "primary_sp" {
  client_id  = azuread_application.primary.client_id
  depends_on = [azuread_application.primary]
}