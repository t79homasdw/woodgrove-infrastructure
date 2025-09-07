terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.7.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.work_sub_id
  tenant_id       = var.work_tenant_id
}

provider "azuread" {
  tenant_id     = var.ext_tenant_id
  client_id     = var.ext_client_id
  client_secret = var.ext_client_secret
}

provider "azuread" {
  tenant_id = var.work_tenant_id
  alias     = "workforce"
}