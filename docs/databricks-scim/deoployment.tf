terraform {
  required_version = ">=0.13"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }
}

provider "azuread" {
  disable_terraform_partner_id = true
  environment                  = "public"
}

# Variables
variable "databricks_account_id" {
  description = "Specifies the id of the Azure Databricks account."
  type        = string
  nullable    = false
  sensitive   = false
  validation {
    condition     = length(var.databricks_account_scim_api_endpoint_url) > 2
    error_message = "Please provide a valid account id."
  }
}

variable "databricks_scim_token" {
  description = "Specifies the id of the Azure Databricks account."
  type        = string
  nullable    = false
  sensitive   = false
  validation {
    condition     = length(var.databricks_account_scim_api_endpoint_url) > 2
    error_message = "Please provide a valid account id."
  }
}

locals {
  databricks_account_scim_api_endpoint_url = "https://accounts.azuredatabricks.net/api/2.1/accounts/${var.databricks_account_id}/scim/v2"
}

# Data
data "azuread_application_template" "databricks_scim" {
  display_name = "Azure Databricks SCIM Provisioning Connector"
}
