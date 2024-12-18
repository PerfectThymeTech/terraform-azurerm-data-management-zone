output "subnet_id_private_endpoints" {
  description = "Specifies the private endpoint subnet id."
  sensitive   = false
  value       = "${azapi_update_resource.virtual_network.id}/subnets/${local.subnet_private_endpoints.name}"
}

output "subnet_ids_databricks" {
  description = "Specifies the Databricks subnet details."
  sensitive   = false
  value = {
    for location in var.locations_databricks :
    location => {
      vnet_id                        = azurerm_virtual_network.virtual_network_databricks[location].id
      subnet_databricks_private_name = local.subnet_databricks_private_name
      subnet_databricks_private_id   = "${azurerm_virtual_network.virtual_network_databricks[location].id}/subnets/${local.subnet_databricks_private_name}"
      subnet_databricks_public_name  = local.subnet_databricks_public_name
      subnet_databricks_public_id    = "${azurerm_virtual_network.virtual_network_databricks[location].id}/subnets/${local.subnet_databricks_public_name}"
    }
  }
}

output "private_dns_zone_ids" {
  description = "Specifies the ids of the private dns zones for Databricks workspaces."
  sensitive   = false
  value       = {
    for key, value in local.private_dns_zone_names:
    key => azurerm_private_dns_zone.private_dns_zone[key].id
  }
}
