resource "azurerm_private_endpoint" "private_endpoint_databricks_workspace_databricks_ui_api" {
  for_each = toset(var.locations_databricks)

  name                = "${module.databricks_workspace[each.key].databricks_workspace_name}-uiapi-pe"
  location            = each.key
  resource_group_name = azurerm_resource_group.connectivity_adb_rg[each.key].name
  tags                = var.tags

  custom_network_interface_name = "${module.databricks_workspace[each.key].databricks_workspace_name}-uiapi-nic"
  private_service_connection {
    name                           = "${module.databricks_workspace[each.key].databricks_workspace_name}-uiapi-svc"
    is_manual_connection           = false
    private_connection_resource_id = module.databricks_workspace[each.key].databricks_workspace_id
    subresource_names              = ["databricks_ui_api"]
  }
  private_dns_zone_group {
    name = "${module.databricks_workspace[each.key].databricks_workspace_name}-arecord"
    private_dns_zone_ids = [
      var.databricks_private_dns_zone_ids["databricks"].id
    ]
  }
  subnet_id = var.subnet_ids_databricks[each.key].subnet_databricks_private_endpoint_id
}

resource "azurerm_private_endpoint" "private_endpoint_databricks_workspace_dbfs_blob" {
  for_each = toset(var.locations_databricks)

  name                = "${module.databricks_workspace[each.key].databricks_workspace_name}-blob-pe"
  location            = each.key
  resource_group_name = azurerm_resource_group.connectivity_adb_rg[each.key].name
  tags                = var.tags

  custom_network_interface_name = "${module.databricks_workspace[each.key].databricks_workspace_name}-blob-nic"
  private_service_connection {
    name                           = "${module.databricks_workspace[each.key].databricks_workspace_name}-blob-svc"
    is_manual_connection           = false
    private_connection_resource_id = "${module.databricks_workspace[each.key].databricks_workspace_managed_resource_group_id}/providers/Microsoft.Storage/storageAccounts/${module.databricks_workspace[each.key].databricks_workspace_managed_storage_account_name}"
    subresource_names              = ["blob"]
  }
  private_dns_zone_group {
    name = "${module.databricks_workspace[each.key].databricks_workspace_name}-arecord"
    private_dns_zone_ids = [
      var.databricks_private_dns_zone_ids["blob"].id
    ]
  }
  subnet_id = var.subnet_ids_databricks[each.key].subnet_databricks_private_endpoint_id
}

resource "azurerm_private_endpoint" "private_endpoint_databricks_workspace_dbfs_dfs" {
  for_each = toset(var.locations_databricks)

  name                = "${module.databricks_workspace[each.key].databricks_workspace_name}-dfs-pe"
  location            = each.key
  resource_group_name = azurerm_resource_group.connectivity_adb_rg[each.key].name
  tags                = var.tags

  custom_network_interface_name = "${module.databricks_workspace[each.key].databricks_workspace_name}-dfs-nic"
  private_service_connection {
    name                           = "${module.databricks_workspace[each.key].databricks_workspace_name}-dfs-svc"
    is_manual_connection           = false
    private_connection_resource_id = "${module.databricks_workspace[each.key].databricks_workspace_managed_resource_group_id}/providers/Microsoft.Storage/storageAccounts/${module.databricks_workspace[each.key].databricks_workspace_managed_storage_account_name}"
    subresource_names              = ["dfs"]
  }
  private_dns_zone_group {
    name = "${module.databricks_workspace[each.key].databricks_workspace_name}-arecord"
    private_dns_zone_ids = [
      var.databricks_private_dns_zone_ids["dfs"].id
    ]
  }
  subnet_id = var.subnet_ids_databricks[each.key].subnet_databricks_private_endpoint_id
}
