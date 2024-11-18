module "databricks_access_connector" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/userassignedidentity?ref=main"
  providers = {
    azurerm = azurerm
  }

  location                         = var.location
  resource_group_name              = azurerm_resource_group.unity_rg.name
  tags                             = var.tags
  databricks_access_connector_name = "${local.prefix}-dbac001"
}
