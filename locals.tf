locals {
  location            = var.rg_location
  resource_group_name = var.rg_name

  backup_sas_token = "data.azurerm_storage_account_sas.backup.sas"

  storage_name = "${var.storage_name}${random_string.suffix.result}"

  #api_app_path     = ["api://${azuread_application.app_perms.application_id}/profile-api"]
  #api_profile_path = ["api://${azuread_application.profile_mod.application_id}/payments-api"]

  appreg_redirect         = "https://${azurerm_windows_web_app.webapp1.default_hostname}/signin-oidc"
  appreg_redirect1        = "https://jwt.ms/"
  appreg_redirect2        = "https://${azurerm_windows_web_app.webapp5.default_hostname}/Auth/AssertionConsumerService"
  sso_destination         = "https://${local.ciamlogin_domain}/${var.ext_tenant_id}/saml2"
  allowed_issuer          = "https://${var.ext_tenant_id}.ciamlogin.com/${var.ext_tenant_id}/v2.0"
  federation_metadata_url = "https://${local.ciamlogin_domain}/${var.ext_tenant_id}/federationmetadata/2007-06/federationmetadata.xml?${azuread_application.bank_demo.client_id}"

  cert_subject_name1 = "CN=api://${local.onmicrosoft_domain}/primary-api"
  cert_subject_name2 = "CN=api://${local.onmicrosoft_domain}/profile-api"
  cert_subject_name3 = "CN=api://${local.onmicrosoft_domain}/payment-api"

  cert_san1 = azuread_application.primary.client_id
  cert_san2 = azuread_application.profile_mod.client_id
  cert_san3 = azuread_application.app_perms.client_id
  cert_san4 = local.onmicrosoft_domain

  # These locals will re-evaluate when sas_rotation.id changes
  sas_start  = formatdate("YYYY-MM-DD'T'hh:mm:ss'Z'", timestamp())
  sas_expiry = formatdate("YYYY-MM-DD'T'hh:mm:ss'Z'", timeadd(timestamp(), "${var.rotation_interval_hours}h"))

  #sas_start              = var.freeze_sas ? var.sas_start_fixed : timestamp() # frozen for testing
  #sas_expiry             = var.freeze_sas ? var.sas_expiry_fixed : timeadd(timestamp(), "8760h") # frozen for testing
  container_url_with_sas = "${azurerm_storage_account.backup.primary_blob_endpoint}${azurerm_storage_container.backup.name}?${data.azurerm_storage_account_sas.backup.sas}"


  #################################################################################
  # Capture Domain for Azure CIAM Tenant
  #################################################################################

  onmicrosoft_domain = lower(coalesce(
    try([
      for d in data.azuread_domains.current.domains : d.domain_name
      if can(regex("onmicrosoft\\.com$", d.domain_name))
    ][0], null),
    data.azuread_domains.current.domains[0].domain_name
  ))

  ciamlogin_domain = lower(replace(local.onmicrosoft_domain, "onmicrosoft.com", "ciamlogin.com"))

  #################################################################################
  #Define Scopes for App Registrations - Delegated Rights
  #################################################################################

  msgraph_scopes_app = [
    "AuditLog.Read.All",
    "User.Read",
    "User.Read.All",
    "User.ReadWrite",
    "User.ReadWrite.All",
    "UserAuthenticationMethod.Read",
    "UserAuthenticationMethod.ReadWrite",
    "UserAuthenticationMethod.ReadWrite.All"
  ]

  msgraph_scopes_primary = [
    "email",
    "Group.Read.All",
    "GroupMember.Read.All",
    "offline_access",
    "openid",
    "profile",
    "User.Read"
  ]

  msgraph_scopes_userprofile = [
    "email",
    "Group.Read.All",
    "GroupMember.Read.All",
    "GroupMember.ReadWrite.All",
    "offline_access",
    "openid",
    "profile",
    "User.Read",
    "User.Read.All",
    "User.ReadWrite",
    "User.ReadWrite.All",
    "UserAuthenticationMethod.Read.All",
    "UserAuthenticationMethod.ReadWrite"
  ]

  #################################################################################
  #Define Roles for App Registrations - Application Rights
  #################################################################################

  msgraph_roles_app = [
    "AuditLog.Read.All",
    "Group.Read.All",
    "GroupMember.ReadWrite.All",
    "User.ManageIdentities.All",
    "User.ReadWrite.All",
    "UserAuthenticationMethod.ReadWrite.All"
  ]
  msgraph_roles_primary = [
    "AppRoleAssignment.ReadWrite.All",
    "AuditLog.Read.All",
    "GroupMember.Read.All",
    "GroupMember.ReadWrite.All",
    "User.ManageIdentities.All",
    "User.Read.All",
    "User.ReadWrite.All",
    "UserAuthenticationMethod.Read.All",
    "UserAuthenticationMethod.ReadWrite.All"
  ]
  msgraph_roles_userprofile = [
    "User.Read.All",
    "UserAuthenticationMethod.Read.All"
  ]

  #################################################################################
  #Lookup Scopes for App Registrations against CIAM Tenant - Delegated Rights
  #################################################################################
  existing_scopes_app = [
    for s in local.msgraph_scopes_app :
    s if lookup(data.azuread_service_principal.msgraph_profile_mod.oauth2_permission_scope_ids, s, null) != null
  ]

  existing_scopes_primary = [
    for s in local.msgraph_scopes_primary :
    s if lookup(data.azuread_service_principal.msgraph_primary.oauth2_permission_scope_ids, s, null) != null
  ]
  existing_scopes_userprofile = [
    for s in local.msgraph_scopes_userprofile :
    s if lookup(data.azuread_service_principal.msgraph_profile_mod.oauth2_permission_scope_ids, s, null) != null
  ]

  #################################################################################
  #Lookup Roles for App Registrations against CIAM Tenant - Application Rights
  #################################################################################
  existing_roles_app = [
    for r in local.msgraph_roles_app :
    r if lookup(data.azuread_service_principal.msgraph_primary.app_role_ids, r, null) != null
  ]
  existing_roles_primary = [
    for r in local.msgraph_roles_primary :
    r if lookup(data.azuread_service_principal.msgraph_primary.app_role_ids, r, null) != null
  ]
  existing_roles_userprofile = [
    for r in local.msgraph_roles_userprofile :
    r if lookup(data.azuread_service_principal.msgraph_profile_mod.app_role_ids, r, null) != null
  ]
}