#---------------------------------------------------------------------------------
#This code generates a random number to be added to variables to ensure unique names
#---------------------------------------------------------------------------------

resource "random_string" "suffix" {
  length  = 6
  numeric = true
  lower   = true
  upper   = false
  special = false
}

#---------------------------------------------------------------------------------
#These are variables that apply to all resources in Azure
#---------------------------------------------------------------------------------

variable "global_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

#---------------------------------------------------------------------------------
#These are variables that apply to individual certificates created in the Workforce Tenant
#---------------------------------------------------------------------------------

variable "cert_name1" {
  description = "Type of Certificate to use"
  type        = string
  default     = "svc-primary-cert"
}

variable "cert_name2" {
  description = "Type of Certificate to use"
  type        = string
  default     = "svc-profile-cert"
}

variable "cert_name3" {
  description = "Type of Certificate to use"
  type        = string
  default     = "svc-app-cert"
}

#---------------------------------------------------------------------------------
#These are variables that apply to all certificates created in the Workforce Tenant
#---------------------------------------------------------------------------------

variable "cert_issuer_type" {
  description = "Type of Certificate to use"
  type        = string
  default     = "Self"
}

variable "cert_exportable_key" {
  description = "Type of Certificate to use"
  type        = string
  default     = true
}
variable "cert_key_size" {
  description = "Type of Certificate to use"
  type        = string
  default     = "2048"
}

variable "cert_key_type" {
  description = "Type of Certificate to use"
  type        = string
  default     = "RSA"
}

variable "cert_reuse_key" {
  description = "Type of Certificate to use"
  type        = string
  default     = true
}

variable "cert_cert_lifetimeaction" {
  description = "Type of Certificate to use"
  type        = string
  default     = "AutoRenew"
}

variable "cert_daysbeforeexpiry" {
  description = "Type of Certificate to use"
  type        = number
  default     = 30
}

variable "cert_content_type" {
  description = "Type of Certificate to use"
  type        = string
  default     = "application/x-pkcs12"
}

variable "cert_validity_in_months" {
  description = "Type of Certificate to use"
  type        = number
  default     = 12
}

variable "cert_extended_key_usage" {
  description = "Type of Certificate to use"
  type        = list(string)
  default     = ["1.3.6.1.5.5.7.3.1"]
}

variable "cert_key_usage" {
  description = "Type of Certificate to use"
  type        = list(string)
  default     = ["digitalSignature", "keyEncipherment"]
}

#---------------------------------------------------------------------------------
#These are variables that apply to app registrations the External Tenant
#---------------------------------------------------------------------------------

#I could not get terraform to push my certificates I have disabled the code
#but I am leaving the configuration in the case that it is working in a future version of terraform

#variable "cert_type" {
#  description = "Type of Certificate to use"
#  type        = string
#  default     = "AsymmetricX509Cert"
#}

#variable "cert_path" {
#  description = "Path for the certificate upload"
#  type        = string
#  default     = "C:/Path/server.cer"
#}

#variable "cert_end_date" {
#  description = "Expiration of Certificate"
#  type        = string
#  default     = "2026-07-10T15:57:18Z"
#}

#variable "cert_value" {
#  description = "Base64-encoded certificate content"
#  type        = string
#  default     = <<EOF
#  -----BEGIN CERTIFICATE-----
#  -----END CERTIFICATE-----
#EOF
#}
#---------------------------------------------------------------------------------
#These variables are for the External Azure Tenant
#---------------------------------------------------------------------------------

variable "ext_tenant_id" {
  description = "External Tenant ID"
  type        = string
  default     = "11111111-1111-1111-1111-111111111111"
}

variable "ext_client_id" {
  description = "External Client ID"
  type        = string
  default     = "11111111-1111-1111-1111-111111111111"
}

variable "ext_client_secret" {
  description = "External Client Secret"
  type        = string
  default     = "*************************************"
}

#---------------------------------------------------------------------------------
#These variables are for the Workforce Azure Tenant
#---------------------------------------------------------------------------------

variable "work_tenant_id" {
  description = "Workforce Tenant ID"
  type        = string
  default     = "11111111-1111-1111-1111-111111111111"
}

variable "work_sub_id" {
  description = "External Subscription ID"
  type        = string
  default     = "11111111-1111-1111-1111-111111111111"
}

variable "work_client_id" {
  description = "External Client ID"
  type        = string
  default     = "11111111-1111-1111-1111-111111111111"
}

variable "work_client_secret" {
  description = "External Client Secret"
  type        = string
  default     = "*************************************"
}

variable "work_alias" {
  description = "Workforce Azure AD Alias"
  type        = string
  default     = "workforce"
}

#---------------------------------------------------------------------------------
#These variables are for the Resoruce Group
#---------------------------------------------------------------------------------

variable "rg_location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "Central US"
}
variable "rg_name" {
  description = "Name of the resource group"
  type        = string
  default     = "<DEMO-NAME>-Dev-Demo"
}

#---------------------------------------------------------------------------------
# These variables are for the storage account
#---------------------------------------------------------------------------------

variable "storage_name" {
  description = "Name of the storage account"
  type        = string
  default     = "demostorage"
}
variable "storage_tier" {
  description = "This is the storage Tier to be used for the storage account"
  type        = string
  default     = "Standard"
}
variable "storage_replication" {
  description = "This is the replication type used for the storage account"
  type        = string
  default     = "LRS"
}
variable "storage_container_name" {
  description = "This is the blob container name created in the storage account"
  type        = string
  default     = "webappbackups"
}
variable "storage_dataprotection_name" {
  description = "This is the blob container name created in the storage account"
  type        = string
  default     = "dataprotection-keys"
}

#---------------------------------------------------------------------------------
#These variables are for the key vault
#---------------------------------------------------------------------------------

variable "kv_name" {
  description = "The Name of the key vault"
  default     = "<DEMO-NAME>-Dev-Demo"
}
variable "kv_sku_pricing_tier" {
  description = "The name of the SKU used for the Key Vault. The options are: `standard`, `premium`."
  default     = "standard"
}
variable "kv_enabled_for_deployment" {
  description = "Allow Virtual Machines to retrieve certificates stored as secrets from the key vault."
  default     = true
}
variable "kv_enable_purge_protection" {
  description = "Is Purge Protection enabled for this Key Vault?"
  default     = false
}
variable "kv_secrets" {
  type        = map(string)
  description = "A map of secrets for the Key Vault."
  default     = {}
}
variable "kv_secret_name" {
  description = "This secret is used to store the SAS token used for backing up the websites."
  default     = "bkup-sas-token"
}
variable "kv_enable_rbac_authorization" {
  description = "Specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions"
  default     = true
}
variable "kv_diag_logs" {
  description = "Keyvault Monitoring Category details for Azure Diagnostic setting"
  default     = ["AuditEvent", "AzurePolicyEvaluationDetails"]
}
variable "kv_access_policies" {
  description = "List of access policies for the Key Vault."
  default     = []
}
variable "kv_admin2" {
  description = "The admin assigned rights to the keyvault."
  default     = "11111111-1111-1111-1111-111111111111"
}

#---------------------------------------------------------------------------------
# These variables are for the log analytics workspace
#---------------------------------------------------------------------------------

variable "la_workspace_name" {
  description = "Specifies the Name of a Log Analytics Workspace where Diagnostics Data to be sent"
  default     = "<DEMO-NAME>-Demo-LogAnalytics"
}
variable "la_workspace_sku" {
  description = "Specifies the SKU of a Log Analytics Workspace where Diagnostics Data to be sent"
  default     = "PerGB2018"
}
variable "la_workspace_retention" {
  description = "Specifies the Retention Rate of a Log Analytics Workspace where Diagnostics Data to be sent"
  default     = 30
}

#---------------------------------------------------------------------------------
# These variables are for the application insights
#---------------------------------------------------------------------------------

variable "appinsights_name" {
  description = "Specifies the Name of a Application Insights that is setup to monitor the websites"
  default     = "<DEMO-NAME>-appinsights-demo"
}
variable "appinsights_apptype" {
  description = "Specifies the Application Type to monitor"
  default     = "web"
}

#---------------------------------------------------------------------------------
# These variables are for the application registration(s)
#---------------------------------------------------------------------------------

variable "appreg_primaryapp" {
  description = "Specifies the Name of an Application Registration that the site can use for Azure API Calls"
  default     = "<DEMO-NAME>-Primary-AppReg"
}

variable "appreg_primarysec" {
  description = "Specifies the Name of an Application Registration that the site can use for Azure API Calls"
  default     = "<DEMO-NAME>-Primary-Secret"
}

variable "appreg_userprofile" {
  description = "Specifies the Name of an Application Registration that the site can use for Azure API Calls"
  default     = "<DEMO-NAME>-UserProfile-AppReg"
}

variable "appreg_userprofilesec" {
  description = "Specifies the Name of an Application Registration that the site can use for Azure API Calls"
  default     = "<DEMO-NAME>-UserProfile-Secret"
}

variable "appreg_appperms" {
  description = "Specifies the Name of an Application Registration that the site can use for Azure API Calls"
  default     = "<DEMO-NAME>-AppPerms-AppReg"
}

variable "appreg_appsec" {
  description = "Specifies the Name of an Application Registration that the site can use for Azure API Calls"
  default     = "<DEMO-NAME>-AppPerms-Secret"
}

variable "appreg_bankdemo" {
  description = "Specifies the Name of an Application Registration that the Bank site can use for Azure API Calls"
  default     = "<DEMO-NAME>-BankDemo"
}


#---------------------------------------------------------------------------------
# These variables are for the application service plan
#---------------------------------------------------------------------------------

variable "asp_name" {
  description = "Specifies the Name of a Application Service Plan the 'ASP' is responsible for providing resources to the Web Apps"
  default     = "<DEMO-NAME>-appserviceplan-win"
}

variable "asp_os_type" {
  description = "Specifies the Operating system to be used for the Web Applications"
  default     = "Windows"
}

variable "asp_reserved" {
  description = "This specifies whether to reservice resources for the Web Applications and involves a cost"
  default     = "false"
}

variable "asp_tier" {
  description = "Specifies the Tier the web apps will use"
  default     = "Standard"
}

variable "asp_sku_name" {
  description = "Specifies the SKU name that the web apps will use note that each size has it's own CPU / Memory"
  default     = "S1"
}

#---------------------------------------------------------------------------------
# These variables are for the communication service
#---------------------------------------------------------------------------------


variable "com_service_name" {
  description = "Specifies the Name of the Communication Service.  This is the service that allows users to send out emails and sending SMS messages.  This may ultimately not be needed if the intent to use Exchange Online."
  default     = "<DEMO-NAME>demo-commservice"
}

variable "com_data_loc" {
  description = "Specifies the Locations for the Communications Service"
  default     = "United States"
}

variable "email_service_name" {
  description = "Name of the Email Communication Service"
  type        = string
  default     = "<DEMO-NAME>demo"
}

#---------------------------------------------------------------------------------
# These variables are for the api management service
#---------------------------------------------------------------------------------

variable "apim_name" {
  description = "Specifies the Name of a API Management Service this is used to send external API calls to our Web Apps"
  default     = "<DEMO-NAME>-apim-demo" # starts with a letter, ends with a letter/number, uses only letters/numbers/hyphens
}
variable "apim_publisher" {
  description = "Specifies the Publisher of the API Management Service"
  default     = "<COMPANY-NAME>"
}
variable "apim_publisher_email" {
  description = "Specifies the Publisher email of the API Management Service.  I would recommend using a DL rather than direct email."
  default     = "user@domain.com"
}
variable "apim_sku" {
  description = "This specifies the SKU to be used for the APIM Service"
  default     = "Developer_1"
}
variable "apim_api_name" {
  description = "This is the name of the API that is being used."
  default     = "woodgroveapi"
}
variable "apim_api_revision" {
  description = "This is the revision of the API that is being used."
  default     = "1"
}
variable "apim_display_name" {
  description = "Specifies the Publisher of the API Management Service"
  default     = "woodgroveapi"
}
variable "apim_path" {
  description = "Specifies the Publisher of the API Management Service"
  default     = "woodgroveapi"
}

#---------------------------------------------------------------------------------
# These are common variables that define the settings for the web application(s)
#---------------------------------------------------------------------------------

variable "web_https_only" {
  description = "This forces the Web App to use https only."
  default     = "true"
}
variable "web_client_affinity_enabled" {
  description = "This setting will enable or disable client affinity."
  default     = "true"
}
variable "web_auth_enabled" {
  description = "This setting will enable or disable web authentication on your web app."
  default     = "false"
}
variable "web_require_authentication" {
  description = "This setting requires authorization to your web app."
  default     = "true"
}
variable "web_require_https" {
  description = "This setting requires https but is is different from https only and is here for auditing purposes."
  default     = "true"
}
variable "web_default_provider" {
  description = "This is the default authentication provider for your site."
  default     = "azureactivedirectory"
}
variable "web_unauthenticated_action" {
  description = "This is the action for the site to take when the user is unauthenticated."
  default     = "Return401"
}
variable "web_token_store_enabled" {
  description = "You can change this option to false to prevent storing tokens."
  default     = "true"
}
variable "web_client_id" {
  description = "This is the ID of the Application Registration used for back end authenticiaton and API calls"
  default     = "11111111-1111-1111-1111-111111111111"
}
#---------------------------------------------------------------------------------
# These are common variables are for the web applications site config
#---------------------------------------------------------------------------------

variable "site_always_on" {
  description = "This setting ensures that the website always stays on..."
  default     = "true"
}
variable "site_ftps_state" {
  description = "This setting will turn on or off the ftps.  Note this needs to be enabled to perform updates tot he site."
  default     = "Disabled"
}
variable "site_min_tls_version" {
  description = "This is the minimum TLS version that can be used for the site."
  default     = "1.2"
}
variable "site_scm_min_tls_version" {
  description = "This is another minimum TLS version that can be used for the site."
  default     = "1.2"
}
variable "site_use_32_bit_worker_process" {
  description = "This setting forces the site to use a 32 bit worker."
  default     = "true"
}
variable "managed_pipeline_mode" {
  description = "This setting allows a managed pipeline to the web apps."
  default     = "Integrated"
}

#---------------------------------------------------------------------------------
# These are common related to .Net Configuration that are commom to all sites.
#---------------------------------------------------------------------------------

variable "current_stack" {
  description = "This property defines the current stack for the app sites."
  default     = "dotnet"
}
variable "dotnet_version" {
  description = "This setting sets the version of dot net framework for the web apps to use."
  default     = "v9.0"
}

#---------------------------------------------------------------------------------
# These are custom application settings and are commom to all sites.
#---------------------------------------------------------------------------------

variable "ASPNETCORE_ENVIRONMENT" {
  description = "This defines the enviroment that is running."
  default     = "Development"
}
variable "WEBSITE_LOAD_CERTIFICATES" {
  description = "This adds a custom setting that allows the site to use loaded certificates."
  default     = "*"
}
variable "WEBSITE_LOAD_USER_PROFILE" {
  description = "This adds a custom setting that allows the site to use loaded certificates."
  default     = "1"
}

#---------------------------------------------------------------------------------
# These are custom names for the web applications and are unique to each site.
#---------------------------------------------------------------------------------

variable "webapp1_name" {
  description = "This is the name for WebApp1."
  default     = "<DEMO-NAME>-demo"
}
variable "webapp2_name" {
  description = "This is the name for WebApp2."
  default     = "<DEMO-NAME>-groceries-api"
}
variable "webapp3_name" {
  description = "This is the name for WebApp3."
  default     = "<DEMO-NAME>-middleware"
}
variable "webapp4_name" {
  description = "This is the name for WebApp4."
  default     = "<DEMO-NAME>-auth-api"
}
variable "webapp5_name" {
  description = "This is the name for WebApp4."
  default     = "<DEMO-NAME>-bank"
}

#---------------------------------------------------------------------------------
# These are for the SAS Key.
#---------------------------------------------------------------------------------

variable "freeze_sas" {
  description = "When true, use fixed timestamps to avoid SAS rotation while developing"
  type        = bool
  default     = false
}

variable "sas_start_fixed" {
  type = string
  # Set to a recent past time in RFC3339 so it's already valid
  default = "2025-09-01T00:00:00Z"
}

variable "sas_expiry_fixed" {
  type = string
  # Keep far enough in the future while you iterate
  default = "2026-09-01T00:00:00Z"
}

variable "rotation_interval_hours" {
  type    = number
  default = 720 # 30 days
}
