locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  # General locals
  diagnostics_configurations = var.log_analytics_workspace_id == null ? [] : [
    {
      log_analytics_workspace_id = var.log_analytics_workspace_id
      storage_account_id         = ""
    }
  ]
  customer_managed_key = null

  # Network locals
  virtual_network = {
    resource_group_name = split("/", var.vnet_id)[4]
    name                = split("/", var.vnet_id)[8]
  }
  network_security_group = {
    resource_group_name = try(split("/", var.nsg_id)[4], "")
    name                = try(split("/", var.nsg_id)[8], "")
  }
  route_table = {
    resource_group_name = try(split("/", var.route_table_id)[4], "")
    name                = try(split("/", var.route_table_id)[8], "")
  }
  subnet_cidr_ranges = {
    private_endpoint_subnet   = var.subnet_cidr_ranges.private_endpoint_subnet != "" ? var.subnet_cidr_ranges.private_endpoint_subnet : tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 27 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 0))
    databricks_private_subnet = var.subnet_cidr_ranges.databricks_private_subnet != "" ? var.subnet_cidr_ranges.databricks_private_subnet : tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 26 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 1))
    databricks_public_subnet  = var.subnet_cidr_ranges.databricks_public_subnet != "" ? var.subnet_cidr_ranges.databricks_public_subnet : tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 26 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 2))
  }
  connectivity_delay_in_seconds  = 10
  databricks_private_subnet_name = "DatabricksPrivateSubnet"
  databricks_public_subnet_name  = "DatabricksPublicSubnet"

  # Databricks locals
  databricks_account_scim_secret_name = "scim-token"
}
