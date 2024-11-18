output "container_registry_id" {
  description = "Specifies the id of the container registry."
  value       = module.container_registry.container_registry_id
  sensitive   = false
}

output "key_vault_id" {
  description = "Specifies the id of the Azure key vault provisioned for Microsoft Purview."
  value       = module.key_vault.key_vault_id
  sensitive   = false
}

output "purview_id" {
  description = "Specifies the id of the Microsoft Purview account."
  value       = module.purview_account.purview_account_id
  sensitive   = false
}

output "synapse_private_link_hub_id" {
  description = "Specifies the id of the Azure synapse private link hub."
  value       = module.synapse_private_link_hub.synapse_private_link_hub_id
  sensitive   = false
}

# output "databricks_workspace_id" {
#   description = "Specifies the id of the databricks workspace."
#   value       = azurerm_databricks_workspace.databricks.id
#   sensitive   = false
# }

# output "databricks_access_connector_id" {
#   description = "Specifies the id of the databricks access connector."
#   value       = azurerm_databricks_access_connector.databricks_access_connector.id
#   sensitive   = false
# }

# output "databricks_metastore_id" {
#   description = "Specifies the id of the databricks metastore."
#   value       = databricks_metastore.metastore.id
#   sensitive   = false
# }
