module "databricks_workspace" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/databricksworkspace?ref=main"
  providers = {
    azurerm = azurerm
    time    = time
  }

  for_each = toset(var.locations_databricks)

  location                                                                  = each.value
  location_private_endpoint                                                 = var.location
  resource_group_name                                                       = azurerm_resource_group.connectivity_adb_rg[each.key].name
  tags                                                                      = var.tags
  databricks_workspace_name                                                 = "${local.prefix}-${each.value}-dbw001"
  databricks_workspace_access_connector_id                                  = module.databricks_access_connector[each.key].databricks_access_connector_id
  databricks_workspace_machine_learning_workspace_id                        = null
  databricks_workspace_virtual_network_id                                   = azurerm_virtual_network.virtual_network_databricks[each.key].id
  databricks_workspace_private_subnet_name                                  = local.databricks_private_subnet_name
  databricks_workspace_private_subnet_network_security_group_association_id = "${azurerm_virtual_network.virtual_network_databricks[each.key].id}/subnets/${local.databricks_private_subnet_name}"
  databricks_workspace_public_subnet_name                                   = local.databricks_public_subnet_name
  databricks_workspace_public_subnet_network_security_group_association_id  = "${azurerm_virtual_network.virtual_network_databricks[each.key].id}/subnets/${local.databricks_public_subnet_name}"
  databricks_workspace_storage_account_sku_name                             = var.zone_redundancy_enabled ? "Standard_ZRS" : "Standard_LRS"
  databricks_workspace_browser_authentication_private_endpoint_enabled      = true
  diagnostics_configurations                                                = local.diagnostics_configurations
  subnet_id                                                                 = azapi_resource.private_endpoint_subnet.id
  connectivity_delay_in_seconds                                             = local.connectivity_delay_in_seconds
  private_dns_zone_id_databricks                                            = var.private_dns_zone_id_databricks
  customer_managed_key                                                      = local.customer_managed_key
}
