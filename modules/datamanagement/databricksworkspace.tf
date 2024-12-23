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
  databricks_workspace_name                                                 = "${local.prefix}-${each.key}-dbw001"
  databricks_workspace_access_connector_id                                  = module.databricks_access_connector[each.key].databricks_access_connector_id
  databricks_workspace_machine_learning_workspace_id                        = null
  databricks_workspace_virtual_network_id                                   = var.subnet_ids_databricks[each.key].vnet_id
  databricks_workspace_private_subnet_name                                  = var.subnet_ids_databricks[each.key].subnet_databricks_private_name
  databricks_workspace_private_subnet_network_security_group_association_id = var.subnet_ids_databricks[each.key].subnet_databricks_private_id
  databricks_workspace_public_subnet_name                                   = var.subnet_ids_databricks[each.key].subnet_databricks_public_name
  databricks_workspace_public_subnet_network_security_group_association_id  = var.subnet_ids_databricks[each.key].subnet_databricks_public_id
  databricks_workspace_storage_account_sku_name                             = var.zone_redundancy_enabled ? "Standard_ZRS" : "Standard_LRS"
  databricks_workspace_browser_authentication_private_endpoint_enabled      = true
  diagnostics_configurations                                                = var.diagnostics_configurations
  subnet_id                                                                 = var.subnet_id_private_endpoints
  connectivity_delay_in_seconds                                             = var.connectivity_delay_in_seconds
  private_dns_zone_id_databricks                                            = var.private_dns_zone_id_databricks
  customer_managed_key                                                      = var.customer_managed_key
}
