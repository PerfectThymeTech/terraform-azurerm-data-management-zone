output "container_registry_id" {
  description = "Specifies the id of the container registry."
  value       = module.container_registry.container_registry_id
  sensitive   = false
}

output "key_vault_purview_id" {
  description = "Specifies the id of the Azure key vault provisioned for Microsoft Purview."
  value       = module.key_vault_purview.key_vault_id
  sensitive   = false
}

output "key_vault_scim_id" {
  description = "Specifies the id of the Azure key vault provisioned for SCIM."
  value       = module.key_vault_scim.key_vault_id
  sensitive   = false
}

output "purview_id" {
  description = "Specifies the id of the Microsoft Purview account."
  value       = var.purview_enabled ? one(module.purview_account["*"].purview_account_id) : ""
  sensitive   = false
}

output "synapse_private_link_hub_id" {
  description = "Specifies the id of the Azure synapse private link hub."
  value       = module.synapse_private_link_hub.synapse_private_link_hub_id
  sensitive   = false
}

output "databricks_workspace_ids" {
  description = "Specifies the ids of the databricks workspaces."
  value = [
    for key, value in toset(var.locations_databricks) :
    module.databricks_workspace[key].databricks_workspace_id
  ]
  sensitive = false
}

output "databricks_access_connector_id" {
  description = "Specifies the ids of the databricks access connectors."
  value = [
    for key, value in toset(var.locations_databricks) :
    module.databricks_access_connector[key].databricks_access_connector_id
  ]
  sensitive = false
}
