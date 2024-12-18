locals {
  # General locals
  prefix = "${lower(var.prefix)}-${var.environment}"

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

  # Subnet locals
  subnet_databricks_private_name = "DatabricksPrivateSubnet"
  subnet_databricks_public_name  = "DatabricksPublicSubnet"
  subnet_private_endpoints = {
    name = "ServicesSubnet"
    properties = {
      addressPrefix         = var.subnet_cidr_range_private_endpoints
      defaultOutboundAccess = false
      delegations           = []
      ipAllocations         = []
      networkSecurityGroup = {
        id = data.azurerm_network_security_group.network_security_group.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      routeTable = {
        id = data.azurerm_route_table.route_table.id
      }
      serviceEndpointPolicies = []
      serviceEndpoints        = []
    }
  }

  # DNS locals
  private_dns_zone_names = {
    # Azure Databricks
    databricks = "privatelink.azuredatabricks.net",

    # Azure Storage
    blob = "privatelink.blob.core.windows.net",
    dfs  = "privatelink.dfs.core.windows.net",
  }

  # DNS link locals
  private_dns_zone_virtual_network_links = merge([
    for location in var.locations_databricks : {
      for key, value in local.private_dns_zone_names :
      "${location}-${key}" => {
        location_databricks   = location
        private_dns_zone_name = value
      }
    }
  ]...)
}
