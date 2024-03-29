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

provider "azurerm" {
  disable_correlation_request_id = false
  environment                    = "public"
  skip_provider_registration     = false
  storage_use_azuread            = true
  # use_oidc                       = true

  features {
    key_vault {
      purge_soft_delete_on_destroy               = false
      purge_soft_deleted_certificates_on_destroy = false
      purge_soft_deleted_keys_on_destroy         = false
      purge_soft_deleted_secrets_on_destroy      = false
      recover_soft_deleted_key_vaults            = true
      recover_soft_deleted_certificates          = true
      recover_soft_deleted_keys                  = true
      recover_soft_deleted_secrets               = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

provider "azapi" {
  default_location               = var.location
  default_tags                   = var.tags
  disable_correlation_request_id = false
  environment                    = "public"
  skip_provider_registration     = false
  # use_oidc                       = true
}

data "azurerm_client_config" "current" {}
