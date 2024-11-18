terraform {
  required_version = ">=0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.76.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "1.9.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.24.0"
    }
  }

  backend "azurerm" {
    environment          = "public"
    resource_group_name  = "mycrp-prd-cicd"
    storage_account_name = "mycrpprdstg001"
    container_name       = "data-management-zone"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
    # use_oidc             = true
  }
}
