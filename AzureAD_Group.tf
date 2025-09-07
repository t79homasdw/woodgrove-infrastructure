# Create an Azure AD Security Group
resource "azuread_group" "CommercialAccounts" {
  display_name     = "CommercialAccounts"
  description      = "Security group created by Terraform"
  security_enabled = true # Required for security groups
}

resource "azuread_group" "ExclusiveDemos" {
  display_name     = "ExclusiveDemos"
  description      = "Security group created by Terraform"
  security_enabled = true # Required for security groups
}