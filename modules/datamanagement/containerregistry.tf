module "container_registry" {
  source = "github.com/PerfectThymeTech/terraform-azurerm-modules//modules/containerregistry?ref=main"
  providers = {
    azurerm = azurerm
    time    = time
  }

  location                                     = var.location
  resource_group_name                          = azurerm_resource_group.container_rg.name
  tags                                         = var.tags
  container_registry_name                      = replace("${local.prefix}-acr001", "-", "")
  container_registry_admin_enabled             = false
  container_registry_anonymous_pull_enabled    = false
  container_registry_data_endpoint_enabled     = false
  container_registry_export_policy_enabled     = false
  container_registry_quarantine_policy_enabled = false
  container_registry_retention_policy_in_days  = 7
  container_registry_trust_policy_enabled      = false
  container_registry_zone_redundancy_enabled   = var.zone_redundancy_enabled
  diagnostics_configurations                   = var.diagnostics_configurations
  subnet_id                                    = var.subnet_id_private_endpoints
  connectivity_delay_in_seconds                = var.connectivity_delay_in_seconds
  private_dns_zone_id_container_registry       = var.private_dns_zone_id_container_registry
  customer_managed_key                         = var.customer_managed_key
}
