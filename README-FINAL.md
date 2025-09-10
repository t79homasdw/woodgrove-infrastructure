
# Woodgrove Infrastructure (CIAM Demo)

End-to-end Terraform for a Woodgrove-style demo environment spanning **Azure CIAM (External ID) app registrations**, **Azure AD (workforce) integration**, **Key Vault + certs/secrets**, **Storage + SAS rotation**, **App Service (5 web apps)**, **API Management**, **Azure Communication Services (Email)**, **Application Insights**, and **Log Analytics**.

> **Tenants:**
> - **Workforce tenant & subscription** — hosts Azure resources (RG, KV, Storage, APIM, ACS, App Service, LA/AI).
> - **CIAM tenant** — hosts app registrations (Primary, UserProfile API, Payment/API), SAML Bank enterprise app, permissions & pre-authorizations.

## Architecture
```mermaid
flowchart LR
  subgraph CIAM Tenant
    AADP[Primary App Reg]
    AADU[UserProfile API App Reg]
    AADA[Payment/API App Reg]
    AADB[Bank SAML App]
  end

  subgraph Workforce Tenant
    RG[Resource Group]
    KV[(Key Vault)]
    SA[(Storage Account)
webappbackups / dataprotection-keys]
    LAW[(Log Analytics)]
    AI[(App Insights)]
    ASP>App Service Plan]
    APIM[[API Management]]
    ACS[[Communication Service + Email]]
    W1[WebApp1 Demo]
    W2[WebApp2 Groceries API]
    W3[WebApp3 Middleware]
    W4[WebApp4 Auth API]
    W5[WebApp5 Bank]
  end

  AADP -->|pre-authorized| AADU
  AADP -->|pre-authorized| AADA
  KV <-->|certs & secrets| AADP & AADU & AADA
  W1 & W2 & W3 & W4 & W5 -->|MSI| KV
  W1 & W2 & W3 & W4 -->|daily backups| SA
  AI --> LAW
  APIM --> W2 & W3 & W4
```

## What this deploys
- **Resource Group** and region.
- **Storage account** + containers (`webappbackups`, `dataprotection-keys`), **SAS generation** & **rotation** (via `time_rotating`) with the SAS stored in **Key Vault**.
- **Key Vault** with **certificates** (Primary/Profile/App) and **secrets** (app client secrets; rotated SAS token). Access for admins, App Service RP, and each web app MI.
- **App Service Plan** (Windows) and **five Web Apps** with Auth v2 plumbed (optional), .NET stack, AI/LAW instrumentation, and KV-based settings.
- **ARM-based backup configuration** for each app (daily, 30-day retention) using the rotated SAS.
- **APIM** with system-assigned identity and a placeholder API (replace with your own).
- **Communication Services (Email)** with Azure-managed domain association.
- **CIAM** app registrations & SAML enterprise app with pre-authorized scopes; secrets stored in KV; certs uploaded to CIAM via Az CLI.

## Prerequisites
- **Terraform** 1.5+ and Azure CLI.
- Permissions:
  - Workforce subscription: ability to create RG, KV, Storage, APIM, ACS, App Service, LAW/AI, role assignments.
  - CIAM tenant: ability to create **app registrations**, service principals, permissions/pre-auth, and **add credentials**.
- For cert upload: host running `az` with service principals for **both** tenants.

## Configure providers
`provider.tf` pins: `azurerm ~> 4.x`, `azuread >= 2.7`, and `random ~> 3.6`. Two Azure AD providers are configured: default points to **CIAM** (client credentials), alias `workforce` points to the **workforce** tenant. Update `variables.tf` (tenant/subscription/client IDs & secrets) and, preferably, source secrets from your CI/CD system.

## Variables
All variables live in `variables.tf`. Minimal overrides go in `terraform.tfvars` (or environment-specific tfvars). Key settings:
- `ext_*` and `work_*` for tenant/subscription and identities.
- `rg_*`, `kv_*`, `storage_*` for platform.
- `asp_*`, `webapp*_name`, `.NET` version, and web auth knobs.
- `rotation_interval_hours` for SAS rotation.

## Quick start
```bash
# 1) Login to the workforce subscription
az login
az account set --subscription <WORK_SUBSCRIPTION_ID>

# 2) Initialize and preview
terraform init
terraform plan -var-file="terraform.tfvars"

# 3) Apply
terraform apply -var-file="terraform.tfvars"
```
After apply, inspect `output.tf` values for app IDs, consent URLs, SAML info, and endpoints.

## Post-deploy steps
- **APIM**: replace the Petstore OpenAPI with your API, add JWT validation policies against CIAM, and configure per-API settings.
- **SAML (Bank)**: set **Entity ID** and **Reply URL** in the Enterprise App to match the WebApp5 URLs from outputs.
- **User flows (CIAM)**: create sign-up/sign-in and profile edit flows (currently manual; see `scripts/userflow.ps1` for future automation).

## Security notes
- **Key Vault RBAC vs Access Policies**: the repo currently defines both. Choose one approach; if `kv_enable_rbac_authorization = true`, disable access policy resources via conditional `count`. If you prefer access policies, set RBAC to `false`.
- **Secrets**: prefer **certificates** over client secrets for app creds. Where secrets are used, set short expiry and alerts.
- **Identity in CI/CD**: use **federated OIDC** for GitHub/Azure DevOps instead of storing client secrets.

## Troubleshooting
- If web apps can’t read certs, verify the **App Service RP** access policy in KV and the **WEBSITE_LOAD_CERTIFICATES** setting.
- If backups fail, confirm the **SAS secret** in KV is valid and rotation logic ran; check Storage RBAC for each web app.
- For CIAM cert upload, verify both tenant logins and `az ad app credential reset --cert` permissions.

## Contributing
PRs welcome. Run `terraform fmt` and ensure plans are clean. Keep provider versions pinned.

---

### Appendix: Files
See **CODEBASE-INVENTORY.md** for a full per-file description.
