# General variables
variable "company_name" {
  description = "Specifies the name of the company."
  type        = string
  sensitive   = false
}

variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
}

variable "location_purview" {
  description = "Specifies the location for Microsoft Purview. The location of Purview is bound to the Microsoft Entra ID location."
  type        = string
  sensitive   = false
}

variable "locations_databricks" {
  description = "Specifies the list of locations where Databricks workspaces will be deployed."
  type        = list(string)
  sensitive   = false
  default     = []
}

variable "environment" {
  description = "Specifies the environment of the deployment."
  type        = string
  sensitive   = false
  default     = "dev"
  validation {
    condition     = contains(["int", "dev", "tst", "qa", "uat", "prd"], var.environment)
    error_message = "Please use an allowed value: \"int\", \"dev\", \"tst\", \"qa\", \"uat\" or \"prd\"."
  }
}

variable "prefix" {
  description = "Specifies the prefix for all resources created in this deployment."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.prefix) >= 2 && length(var.prefix) <= 10
    error_message = "Please specify a prefix with more than two and less than 10 characters."
  }
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

# Service variables
variable "purview_enabled" {
  description = "Specifies whether Purview should be enabled."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = false
}

variable "purview_account_root_collection_admins" {
  description = "Specifies the root collection admins of the Purview account."
  type = map(object({
    object_id = string
  }))
  sensitive = false
  default   = {}
  validation {
    condition = alltrue([
      length([for root_collection_admin in var.purview_account_root_collection_admins : true if length(root_collection_admin.object_id) <= 2]) <= 0
    ])
    error_message = "Please specify a valid object id."
  }
}

variable "databricks_account_id" {
  description = "Specifies the id of the databricks account."
  type        = string
  sensitive   = false
  nullable    = false
  default     = ""
  validation {
    condition     = var.databricks_account_id == "" || length(var.databricks_account_id) > 2
    error_message = "Please specify a valid databricks account id."
  }
}

# HA/DR variables
variable "zone_redundancy_enabled" {
  description = "Specifies whether zone-redundancy should be enabled for all resources."
  type        = bool
  sensitive   = false
  nullable    = false
  default     = true
}

# Logging and monitoring variables
variable "diagnostics_configurations" {
  description = "Specifies the diagnostic configuration for the service."
  type = list(object({
    log_analytics_workspace_id = optional(string, ""),
    storage_account_id         = optional(string, "")
  }))
  sensitive = false
  default   = []
  validation {
    condition = alltrue([
      length([for diagnostics_configuration in toset(var.diagnostics_configurations) : diagnostics_configuration if diagnostics_configuration.log_analytics_workspace_id == "" && diagnostics_configuration.storage_account_id == ""]) <= 0
    ])
    error_message = "Please specify a valid resource ID."
  }
}

# Network variables
variable "subnet_id_private_endpoints" {
  description = "Specifies the id of the private endpoint subnet used for the data management services."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.subnet_id_private_endpoints)) == 11
    error_message = "Please specify a valid resource ID."
  }
}

variable "subnet_ids_databricks" {
  description = "Specifies the ids of the subnets for the databricks workspaces."
  type = map(object({
    vnet_id                        = string
    subnet_databricks_private_name = string
    subnet_databricks_private_id   = string
    subnet_databricks_public_name  = string
    subnet_databricks_public_id    = string
  }))
  sensitive = false
  default   = {}
  validation {
    condition = alltrue([
      for key, value in var.subnet_ids_databricks : length(split("/", value.vnet_id)) == 9
    ])
    error_message = "Please specify a valid vnet id."
  }
  validation {
    condition = alltrue([
      for key, value in var.subnet_ids_databricks : length(split("/", value.subnet_databricks_private_id)) == 11
    ])
    error_message = "Please specify a valid subnet id for the private subnet."
  }
  validation {
    condition = alltrue([
      for key, value in var.subnet_ids_databricks : length(split("/", value.subnet_databricks_public_id)) == 11
    ])
    error_message = "Please specify a valid subnet id for the public subnet."
  }
  validation {
    condition     = length(var.subnet_ids_databricks) == length(var.locations_databricks)
    error_message = "Please specify a subnet for all locations."
  }
}

variable "connectivity_delay_in_seconds" {
  description = "Specifies the delay in seconds after the private endpoint deployment (required for the DNS automation via Policies)."
  type        = number
  sensitive   = false
  nullable    = false
  default     = 120
  validation {
    condition     = var.connectivity_delay_in_seconds >= 0
    error_message = "Please specify a valid non-negative number."
  }
}

# DNS variables
variable "private_dns_zone_id_purview_platform" {
  description = "Specifies the resource ID of the private DNS zone for Azure Key Vault. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  nullable    = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_purview_platform == "" || (length(split("/", var.private_dns_zone_id_purview_platform)) == 9 && endswith(var.private_dns_zone_id_purview_platform, "privatelink.purview-service.microsoft.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_blob" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_blob == "" || (length(split("/", var.private_dns_zone_id_blob)) == 9 && endswith(var.private_dns_zone_id_blob, "privatelink.blob.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_dfs" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage dfs endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_dfs == "" || (length(split("/", var.private_dns_zone_id_dfs)) == 9 && endswith(var.private_dns_zone_id_dfs, "privatelink.dfs.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_queue" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage queue endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_queue == "" || (length(split("/", var.private_dns_zone_id_queue)) == 9 && endswith(var.private_dns_zone_id_queue, "privatelink.queue.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_databricks" {
  description = "Specifies the resource ID of the private DNS zone for Azure Databricks UI endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_databricks == "" || (length(split("/", var.private_dns_zone_id_databricks)) == 9 && endswith(var.private_dns_zone_id_databricks, "privatelink.azuredatabricks.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_container_registry" {
  description = "Specifies the resource ID of the private DNS zone for Azure Container Registry. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_container_registry == "" || (length(split("/", var.private_dns_zone_id_container_registry)) == 9 && endswith(var.private_dns_zone_id_container_registry, "privatelink.azurecr.io"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_synapse_portal" {
  description = "Specifies the resource ID of the private DNS zone for Synapse PL Hub. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_synapse_portal == "" || (length(split("/", var.private_dns_zone_id_synapse_portal)) == 9 && endswith(var.private_dns_zone_id_synapse_portal, "privatelink.azuresynapse.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_vault" {
  description = "Specifies the resource ID of the private DNS zone for Azure Key Vault. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  nullable    = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_vault == "" || (length(split("/", var.private_dns_zone_id_vault)) == 9 && endswith(var.private_dns_zone_id_vault, "privatelink.vaultcore.azure.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

# Customer-managed key variables
variable "customer_managed_key" {
  description = "Specifies the customer managed key configurations."
  type = object({
    key_vault_id                     = string,
    key_vault_key_versionless_id     = string,
    user_assigned_identity_id        = string,
    user_assigned_identity_client_id = string,
  })
  sensitive = false
  nullable  = true
  default   = null
  validation {
    condition = alltrue([
      var.customer_managed_key == null || length(split("/", try(var.customer_managed_key.key_vault_id, ""))) == 9,
      var.customer_managed_key == null || startswith(try(var.customer_managed_key.key_vault_key_versionless_id, ""), "https://"),
      var.customer_managed_key == null || length(split("/", try(var.customer_managed_key.user_assigned_identity_id, ""))) == 9,
      var.customer_managed_key == null || length(try(var.customer_managed_key.user_assigned_identity_client_id, "")) >= 2,
    ])
    error_message = "Please specify a valid resource ID."
  }
}
