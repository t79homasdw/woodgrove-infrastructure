#-------------------------------------------------
# Certificate Upload to CIAM Tenant
#-------------------------------------------------

resource "null_resource" "upload_primary_cert_to_ciam" {
  provisioner "local-exec" {
    interpreter = ["powershell", "-NoProfile", "-NonInteractive", "-ExecutionPolicy", "Bypass", "-Command"]
    command     = <<-PS
      $ErrorActionPreference = 'Stop'

      $primary_cert_base64 = '${trimspace(data.azurerm_key_vault_secret.primary_signing_cert.value)}' 
      $bytes = [Convert]::FromBase64String($primary_cert_base64)
      $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
      $cert.Import($bytes, $null, 'Exportable,PersistKeySet')
      $base64 = [Convert]::ToBase64String($cert.RawData)

      az login --service-principal -u ${var.ext_client_id} -p ${var.ext_client_secret} --tenant ${var.ext_tenant_id} --allow-no-subscriptions
      az ad app credential reset --id ${azuread_application.primary.client_id} --cert  $base64 --append
      az login --service-principal -u ${var.work_client_id} -p ${var.work_client_secret} --tenant ${var.work_tenant_id}

    PS
  }

  depends_on = [
    data.azurerm_key_vault_secret.primary_signing_cert,
    azuread_application.primary,
    azuread_application_password.primary_secret,
    azuread_service_principal.primary_sp
  ]
}

resource "null_resource" "upload_profile_cert_to_ciam" {
  provisioner "local-exec" {
    interpreter = ["powershell", "-NoProfile", "-NonInteractive", "-ExecutionPolicy", "Bypass", "-Command"]
    command     = <<-PS
      $ErrorActionPreference = 'Stop'

      $profile_cert_base64 = '${trimspace(data.azurerm_key_vault_secret.profile_signing_cert.value)}'
      $bytes = [Convert]::FromBase64String($profile_cert_base64)
      $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
      $cert.Import($bytes, $null, 'Exportable,PersistKeySet')
      $base64 = [Convert]::ToBase64String($cert.RawData)

      az login --service-principal -u ${var.ext_client_id} -p ${var.ext_client_secret} --tenant ${var.ext_tenant_id} --allow-no-subscriptions
      az ad app credential reset --id ${azuread_application.profile_mod.client_id} --cert $base64 --append
      az login --service-principal -u ${var.work_client_id} -p ${var.work_client_secret} --tenant ${var.work_tenant_id}

    PS
  }

  depends_on = [
    data.azurerm_key_vault_secret.profile_signing_cert,
    azuread_application.profile_mod,
    azuread_application_password.profile_mod_secret,
    azuread_service_principal.profile_mod_sp
  ]
}

resource "null_resource" "upload_app_cert_to_ciam" {
  provisioner "local-exec" {
    interpreter = ["powershell", "-NoProfile", "-NonInteractive", "-ExecutionPolicy", "Bypass", "-Command"]
    command     = <<-PS
      $ErrorActionPreference = 'Stop'

      $app_cert_base64 = '${trimspace(data.azurerm_key_vault_secret.app_signing_cert.value)}'
      $bytes = [Convert]::FromBase64String($app_cert_base64)
      $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
      $cert.Import($bytes, $null, 'Exportable,PersistKeySet')
      $base64 = [Convert]::ToBase64String($cert.RawData)

      az login --service-principal -u ${var.ext_client_id} -p ${var.ext_client_secret} --tenant ${var.ext_tenant_id} --allow-no-subscriptions
      az ad app credential reset --id ${azuread_application.app_perms.client_id} --cert $base64 --append
      az login --service-principal -u ${var.work_client_id} -p ${var.work_client_secret} --tenant ${var.work_tenant_id}

    PS
  }

  depends_on = [
    data.azurerm_key_vault_secret.app_signing_cert,
    azuread_application.app_perms,
    azuread_application_password.app_perms_secret,
    azuread_service_principal.app_perms
  ]

}