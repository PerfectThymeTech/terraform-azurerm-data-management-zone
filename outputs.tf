# output "container_registry_id" {
#   description = "Specifies the id of the container registry."
#   value       = azurerm_container_registry.container_registry.id
#   sensitive   = false
# }

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

# output "databricks_datalake_id" {
#   description = "Specifies the id of the datalake used as a default for the databricks metastore."
#   value       = azurerm_storage_account.datalake.id
#   sensitive   = false
# }

# output "key_vault_id" {
#   description = "Specifies the id of the Azure key vault provisioned for Microsoft Purview."
#   value       = azurerm_storage_account.datalake.id
#   sensitive   = false
# }

# output "purview_id" {
#   description = "Specifies the id of the Microsoft Purview account."
#   value       = azurerm_storage_account.datalake.id
#   sensitive   = false
# }

# output "synapse_private_link_hub_id" {
#   description = "Specifies the id of the Azure synapse private link hub."
#   value       = azurerm_storage_account.datalake.id
#   sensitive   = false
# }
