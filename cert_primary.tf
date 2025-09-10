#-------------------------------------------------
# Certificate Creation - Primary App Certificate
#-------------------------------------------------

resource "azurerm_key_vault_certificate" "primary_signing_cert" {
  name         = var.cert_name1
  key_vault_id = azurerm_key_vault.main.id

  # Key Vault will generate & issue this certificate
  certificate_policy {
    issuer_parameters { name = var.cert_issuer_type } # self-signed in Key Vault
    key_properties {
      exportable = var.cert_exportable_key # allow export of private key
      key_size   = var.cert_key_size       # 2048 or 4096
      key_type   = var.cert_key_type       # RSA or EC
      reuse_key  = var.cert_reuse_key      # true to reuse when renewing
    }
    lifetime_action {
      action { action_type = var.cert_cert_lifetimeaction } # KV renewal automation
      trigger { days_before_expiry = var.cert_daysbeforeexpiry }
    }
    secret_properties {
      content_type = var.cert_content_type # store as PFX secret
    }
    x509_certificate_properties {
      subject            = local.cert_subject_name1    # e.g. "CN=mydomain.com"
      validity_in_months = var.cert_validity_in_months # e.g. 12 or 24
      # Server Authentication EKU OID 1.3.6.1.5.5.7.3.1
      extended_key_usage = var.cert_extended_key_usage
      key_usage          = var.cert_key_usage
      subject_alternative_names {
        dns_names = [
          local.cert_san1,
          local.cert_san2,
          local.cert_san3,
          local.cert_san4
        ]
      }
    }
  }
  depends_on = [azurerm_key_vault.main,
    azuread_application.primary,
    azuread_application.profile_mod,
    azuread_application.app_perms
  ]
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
