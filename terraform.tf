terraform {
  required_version = ">=0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.58"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
    external = {
      source = "hashicorp/external"
      version = "~> 2.3"
    }
  }
}
