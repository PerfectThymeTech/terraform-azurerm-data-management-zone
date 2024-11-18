module "databricks_workspace" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/databricksworkspace?ref=main"
  providers = {
    azurerm = azurerm
    time    = time
  }

  location                                                                  = var.location
  resource_group_name                                                       = azurerm_resource_group.unity_rg.name
  tags                                                                      = var.tags
  databricks_workspace_name                                                 = "${local.prefix}-cnsmptn-dbw001"
  databricks_workspace_access_connector_id                                  = module.databricks_access_connector.databricks_access_connector_id
  databricks_workspace_machine_learning_workspace_id                        = null
  databricks_workspace_virtual_network_id                                   = data.azurerm_virtual_network.virtual_network.id
  databricks_workspace_private_subnet_name                                  = azapi_resource.databricks_private_subnet.name
  databricks_workspace_private_subnet_network_security_group_association_id = azapi_resource.databricks_private_subnet.id
  databricks_workspace_public_subnet_name                                   = azapi_resource.databricks_public_subnet.name
  databricks_workspace_public_subnet_network_security_group_association_id  = azapi_resource.databricks_public_subnet.id
  databricks_workspace_storage_account_sku_name                             = var.zone_redundancy_enabled ? "Standard_ZRS" : "Standard_LRS"
  databricks_workspace_browser_authentication_private_endpoint_enabled      = true
  diagnostics_configurations                                                = local.diagnostics_configurations
  subnet_id                                                                 = azapi_resource.private_endpoint_subnet.id
  connectivity_delay_in_seconds                                             = local.connectivity_delay_in_seconds
  private_dns_zone_id_databricks                                            = var.private_dns_zone_id_databricks
  customer_managed_key                                                      = local.customer_managed_key
}
