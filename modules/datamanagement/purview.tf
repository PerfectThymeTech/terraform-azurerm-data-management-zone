module "purview_account" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/purview?ref=main"
  providers = {
    azurerm = azurerm
    azapi   = azapi
    time    = time
  }

  count = var.purview_enabled ? 1 : 0

  location                               = var.location_purview
  location_private_endpoint              = var.location
  resource_group_name                    = azurerm_resource_group.governance_rg.name
  tags                                   = var.tags
  purview_account_name                   = "${local.prefix}-pview001"
  purview_account_root_collection_admins = var.purview_account_root_collection_admins
  diagnostics_configurations             = var.diagnostics_configurations
  subnet_id                              = var.subnet_id_private_endpoints
  connectivity_delay_in_seconds          = var.connectivity_delay_in_seconds
  private_dns_zone_id_purview_platform   = var.private_dns_zone_id_purview_platform
  private_dns_zone_id_blob               = var.private_dns_zone_id_blob
  private_dns_zone_id_queue              = var.private_dns_zone_id_queue
}
