terraform {
  required_version = ">=0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.56"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.5"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.16"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "databricks" {
  azure_environment           = "public"
  azure_workspace_resource_id = azurerm_databricks_workspace.databricks.id
  host                        = azurerm_databricks_workspace.databricks.workspace_url
}
