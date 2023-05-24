module "data_management_zone" {
  source = "../"
  providers = {
    azurerm = azurerm
    azure/azapi   = azure/azapi
  }

  company_name = var.company_name
  location = var.location
  environment = var.environment
  prefix = var.prefix
  tags = var.tags
  vnet_id = var.vnet_id
  nsg_id = var.nsg_id
  route_table_id = var.route_table_id
  private_dns_zone_id_namespace = var.private_dns_zone_id_namespace
  private_dns_zone_id_purview_account = var.private_dns_zone_id_purview_account
  private_dns_zone_id_purview_portal = var..private_dns_zone_id_purview_portal
  private_dns_zone_id_blob = var.private_dns_zone_id_blob
  private_dns_zone_id_dfs = var.private_dns_zone_id_dfs
  private_dns_zone_id_queue = var.private_dns_zone_id_queue
  private_dns_zone_id_container_registry = var.private_dns_zone_id_container_registry
  private_dns_zone_id_synapse_portal = var.private_dns_zone_id_synapse_portal
  private_dns_zone_id_key_vault = var.private_dns_zone_id_key_vault
  private_dns_zone_id_databricks = var.private_dns_zone_id_databricks
  purview_root_collection_admins = var.purview_root_collection_admins
  data_platform_subscription_ids = var.data_platform_subscription_ids
}
