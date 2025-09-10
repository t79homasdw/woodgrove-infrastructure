output "a0" { value = "--------------------------------------------------------------------------------" }
output "a1_____Primary_ClientID" { value = azuread_application.primary.client_id }
output "a2_____UserProfile_ClientID" { value = azuread_application.profile_mod.client_id }
output "a3_____UserProfile_API" { value = "api://${local.onmicrosoft_domain}/profile-api" }
output "a4_____AppPerms_ClientID" { value = azuread_application.app_perms.client_id }
output "a5_____AppPerms_API" { value = "api://${local.onmicrosoft_domain}/payment-api" }

output "b0" { value = "--------------------------------------------------------------------------------" }
output "b1_____AppPerms_PrincipalID" { value = azuread_service_principal.primary_sp.id }
output "b2_____CommercialAccounts" { value = azuread_group.CommercialAccounts.id }
output "b3_____Orders_Manager" { value = random_uuid.Orders_Manager.result }
output "b4_____Products_Contributor" { value = random_uuid.Products_Contributor.result }
output "b5_____ExclusiveDemos_SecurityGroup" { value = azuread_group.ExclusiveDemos.id }

output "b6" { value = "--------------------------------------------------------------------------------" }
output "b7_____Bank_AppReg_ClientID" { value = azuread_application.bank_demo.client_id }
output "b8_____Bank_Enterprise_app" { value = azuread_service_principal.bank_sp.object_id }
output "b9a____entity_id" { value = "https://${azurerm_windows_web_app.webapp5.default_hostname}" }
output "b9b____SingleSignOnDest_URL" { value = local.sso_destination }
output "b9c____Allowed_Issuer_URL" { value = local.allowed_issuer }
output "b9d____saml_replyURL" { value = local.appreg_redirect2 }
output "b9e____federation_metadata_url" { value = local.federation_metadata_url }
output "b9f____saml_signing_cert_thumbprint" { value = azuread_service_principal_token_signing_certificate.saml_cert.thumbprint }

output "c0" { value = "--------------------------------------------------------------------------------" }
output "c1_____Workforce_OpenID" { value = "https://login.microsoftonline.com/${var.ext_tenant_id}/v2.0/.well-known/openid-configuration" }
output "c2_____CIAM_OpenID" { value = "https://${local.ciamlogin_domain}/${var.ext_tenant_id}/v2.0/.well-known/openid-configuration" }
output "c3_____CIAM_TenantID" { value = var.ext_tenant_id }

output "c3a" { value = "--------------------------------------------------------------------------------" }
output "c4_____Auth_URL" { value = "The below link will authorize permissions for the Primary App Registration.  Replace the values / scopes as needed for the other client ids" }
output "c5_____WF_Consent" { value = ["https://login.microsoftonline.com/${var.ext_tenant_id}/oauth2/v2.0/authorize?",
  "client_id=${azuread_application.primary.client_id}",
  "&response_type=code",
  "&redirect_uri=${local.appreg_redirect1}",
  "&response_mode=query",
  "&scope=openid profile offline_access api://${local.onmicrosoft_domain}/profile-api api://${local.onmicrosoft_domain}/payment-api",
  "&state=12345",
"&prompt=consent"] }

output "c5a" { value = "--------------------------------------------------------------------------------" }
output "c6_____CIAM_Auth_URL" { value = "The below link will authorize permissions for the Profile App Registration" }
output "c5_____CIAM_Consent" { value = ["https://${local.ciamlogin_domain}/${var.ext_tenant_id}/oauth2/v2.0/authorize?",
  "client_id=${azuread_application.primary.client_id}",
  "&response_type=code",
  "&redirect_uri=${local.appreg_redirect1}",
  "&response_mode=query",
  "&scope=openid profile offline_access api://${local.onmicrosoft_domain}/profile-api api://${local.onmicrosoft_domain}/payment-api",
  "&state=12345",
"&prompt=consent"] }

output "d0" { value = "--------------------------------------------------------------------------------" }
output "d1_____Demo_URL" { value = "https://${azurerm_windows_web_app.webapp1.default_hostname}" }
output "d2_____Groceries_API_URL" { value = "https://${azurerm_windows_web_app.webapp2.default_hostname}" }
output "d3_____Middleware_URL" { value = "https://${azurerm_windows_web_app.webapp3.default_hostname}" }
output "d4_____Auth_API_URL" { value = "https://${azurerm_windows_web_app.webapp4.default_hostname}" }
output "d5_____Bank_API_URL" { value = "https://${azurerm_windows_web_app.webapp5.default_hostname}" }

output "e0" { value = "--------------------------------------------------------------------------------" }
output "e1_____Storage_Account" { value = local.storage_name }
output "e2_____Keyvault" { value = lower("kv-${var.kv_name}") }
output "e3_____acs_hostname" { value = azurerm_communication_service.com-service.hostname }
output "e4_____email_sender_domain" { value = azurerm_email_communication_service_domain.azure_managed.from_sender_domain }

output "f0" { value = "--------------------------------------------------------------------------------" }
output "f1_____App_Cert_Primary" { value = azurerm_app_service_certificate.primary_cert.thumbprint }
output "f2_____App_Cert_Profile" { value = azurerm_app_service_certificate.profile_cert.thumbprint }
output "f2_____App_Cert_App" { value = azurerm_app_service_certificate.app_cert.thumbprint }

output "g0" { value = "--------------------------------------------------------------------------------" }

#output "e2_app_insights_connection_string" { value = azurerm_application_insights.appinsights.connection_string }