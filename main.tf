module "platform" {
  source = "./modules/platform"

  providers = {
    azurerm = azurerm
    azapi   = azapi
  }

  # General variables
  location             = var.location
  locations_databricks = var.locations_databricks
  environment          = var.environment
  prefix               = var.prefix
  tags                 = var.tags

  # Service variables
  vnet_id                             = var.vnet_id
  nsg_id                              = var.nsg_id
  route_table_id                      = var.route_table_id
  subnet_cidr_range_private_endpoints = var.subnet_cidr_ranges.private_endpoint_subnet
}

module "datamanagement" {
  source = "./modules/datamanagement"

  providers = {
    azurerm = azurerm
    azapi   = azapi
    time    = time
  }

  # General variables
  company_name         = var.company_name
  location             = var.location
  location_purview     = var.location_purview
  locations_databricks = var.locations_databricks
  environment          = var.environment
  prefix               = var.prefix
  tags                 = var.tags

  # Service variables
  purview_enabled                        = var.purview_enabled
  purview_account_root_collection_admins = var.purview_account_root_collection_admins
  databricks_account_id                  = var.databricks_account_id

  # HA/DR variables
  zone_redundancy_enabled = var.zone_redundancy_enabled

  # Logging and monitoring variables
  diagnostics_configurations = local.diagnostics_configurations

  # Network variables
  subnet_id_private_endpoints   = module.platform.subnet_id_private_endpoints
  subnet_ids_databricks         = module.platform.subnet_ids_databricks
  connectivity_delay_in_seconds = local.connectivity_delay_in_seconds

  # DNS variables
  private_dns_zone_id_purview_platform   = var.private_dns_zone_id_purview_platform
  private_dns_zone_id_blob               = var.private_dns_zone_id_blob
  private_dns_zone_id_dfs                = var.private_dns_zone_id_dfs
  private_dns_zone_id_queue              = var.private_dns_zone_id_queue
  private_dns_zone_id_databricks         = var.private_dns_zone_id_databricks
  private_dns_zone_id_container_registry = var.private_dns_zone_id_container_registry
  private_dns_zone_id_vault              = var.private_dns_zone_id_vault
  private_dns_zone_id_synapse_portal     = var.private_dns_zone_id_synapse_portal
  databricks_private_dns_zone_ids        = module.platform.private_dns_zone_ids

  # Customer-managed key variables
  customer_managed_key = var.customer_managed_key
}
