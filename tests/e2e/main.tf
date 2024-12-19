module "data_management_zone" {
  source = "../../"
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
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # Network variables
  vnet_id            = var.vnet_id
  nsg_id             = var.nsg_id
  route_table_id     = var.route_table_id
  subnet_cidr_ranges = var.subnet_cidr_ranges

  # DNS variables
  private_dns_zone_id_purview_platform   = var.private_dns_zone_id_purview_platform
  private_dns_zone_id_blob               = var.private_dns_zone_id_blob
  private_dns_zone_id_dfs                = var.private_dns_zone_id_dfs
  private_dns_zone_id_queue              = var.private_dns_zone_id_queue
  private_dns_zone_id_container_registry = var.private_dns_zone_id_container_registry
  private_dns_zone_id_synapse_portal     = var.private_dns_zone_id_synapse_portal
  private_dns_zone_id_vault              = var.private_dns_zone_id_vault
  private_dns_zone_id_databricks         = var.private_dns_zone_id_databricks

  # Customer-managed key variables
  customer_managed_key = var.customer_managed_key
}
