module "data_management_zone" {
  source = "../../"
  providers = {
    azurerm = azurerm
    azapi   = azapi
    time    = time
  }

  # General variables
  company_name = var.company_name
  location     = var.location
  environment  = var.environment
  prefix       = var.prefix
  tags         = var.tags

  # Service variables
  databricks_locations = var.databricks_locations

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
  private_dns_zone_id_namespace          = var.private_dns_zone_id_namespace
  private_dns_zone_id_purview_account    = var.private_dns_zone_id_purview_account
  private_dns_zone_id_purview_portal     = var.private_dns_zone_id_purview_portal
  private_dns_zone_id_blob               = var.private_dns_zone_id_blob
  private_dns_zone_id_dfs                = var.private_dns_zone_id_dfs
  private_dns_zone_id_queue              = var.private_dns_zone_id_queue
  private_dns_zone_id_container_registry = var.private_dns_zone_id_container_registry
  private_dns_zone_id_synapse_portal     = var.private_dns_zone_id_synapse_portal
  private_dns_zone_id_key_vault          = var.private_dns_zone_id_key_vault
  private_dns_zone_id_databricks         = var.private_dns_zone_id_databricks

  # Customer-managed key variables
  customer_managed_key = var.customer_managed_key
}
