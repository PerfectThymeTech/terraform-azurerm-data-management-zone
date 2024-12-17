module "databricks_access_connector" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/databricksaccessconnector?ref=main"
  providers = {
    azurerm = azurerm
  }

  for_each = toset(var.locations_databricks)

  location                         = each.value
  resource_group_name              = azurerm_resource_group.connectivity_adb_rg[each.key].name
  tags                             = var.tags
  databricks_access_connector_name = "${local.prefix}-${each.value}-dbac001"
}
